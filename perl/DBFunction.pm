package DBFunction;

use strict;
use warnings;
use 5.10.0;


sub new {
	my $class = shift;
	my %args = @_;
	
	my $self = {
		name => ($args{name} || ''),
		scope => ($args{scope} || ''),
		self => ($args{self} || undef),
		args => [],
		argStrings => ($args{argStrings} || []),
		'join' => ($args{'join'} || []),
		'return' => ($args{'return'} || []),
		update => ($args{'update'} || []),
		returnn => 0,	
	};
		
	bless $self, $class;
}

sub setUpdates {
	my ($self, @updates) = @_;
	
	push @{$self->{update}}, @updates
}

# how many results we expect back
sub setRetN {
	my ($self, $n) = @_;
	
	$self->{returnn} = $n;
}

sub addName {
	my ($self, $name) = @_;
	
	$self->{name} = $name;
}

sub addArgs {
	my ($self, @args) = @_;
	
	push @{$self->{argStrings}}, @args
}

sub addReturns {
	my ($self, @returns) = @_;
	
	push @{$self->{return}}, @returns
}

sub addJoins {
	my ($self, @joins) = @_;
	
	push @{$self->{join}}, @joins
}

sub getResolvedName {
	my $self = shift;
	return "$self->{scope}_$self->{name}"
}

sub getPHP {
	my $self = shift;
	
	my @args = ();
	
	for my $arg (values %{$self->{args}}) {
		push @args, '$' . $arg->dbArgName
	}
	
	my $dbfn = $self->getResolvedName();
	my @dbargs = ("\"$dbfn\"", @args);

	local $" = ', ';
	
	my $phpfn = 'getRows';
	
	given ($self->{returnn}) {
		when (0) {
			$phpfn = 'callSP';
			break
		}
		when (1) {
			$phpfn = 'getRow';
			break
		}
	}
	return <<EOF;
	public function
	$self->{name}(@args) {
		return Db::$phpfn(@dbargs);
	}
	
EOF
	
	
}

sub printme {
	my $self = shift;
	
	my @args = ();
	my @rets = ();
	my $from = '';
	my @where = ();
	
	
	for my $arg (values %{$self->{args}}) {
		push @args, $arg->printDBArg;
		push @where, $arg->dbClassName . ' = ' . $arg->dbArgName
	}
	
	my %neededClasses = ();
	
	while (my ($class, $argList) = each %{$self->{return}}) {
		for my $ret (@{$argList}) {
			push @rets, $class . '.' . $ret->{name}
		}
		$neededClasses{$class} = 1;
	}
	
	if ($self->{self}) {
		if ($neededClasses{$self->{self}{name}}) {
			delete $neededClasses{$self->{self}{name}};
		}
		$from = '#db#.' . $self->{self}{name};
	}
	
	my ($prevClass, $prevJoin);
	while (my ($class, $argList) = each %{$self->{join}}) {
		if ($neededClasses{$class}) {
			delete $neededClasses{$class};
		}
		
		if ($prevClass) {
			$from .= " INNER JOIN #db#.$class ON ($prevClass.$prevJoin = $class.$argList->[0]{name}) ";
		} 
		else {
			$from = $class;
			$prevClass = $class;
			$prevJoin = $argList->[0]{name};
		}
	}
	
	if (scalar keys %neededClasses) {
		my $classes = join ', ', keys %neededClasses;
		die "Not all classes ($classes) accounted for in $self->{name}.join()"
	}
	
	
	my $argList = join ",\n\t", @args;
	my $retList = join ",\n\t\t", @rets;
	my $whereList = join " AND\n\t\t", @where;
	my $limit = '';
	
	given ($self->{returnn}) {
		when (0) {
			# return nothing..
			# ? dunno why we'd have this..
		}
		when (/^\d+$/) {
			$limit = "\n\tLIMIT $self->{returnn}"
		}
		when (/\*/) {
			# get all
		}		
	}
	
	my $fnname = $self->getResolvedName;
	
	return <<EOF;
DROP PROCEDURE IF EXISTS #db#.$fnname//
CREATE PROCEDURE #db#.$fnname (
	$argList
)
BEGIN
	SELECT 
		$retList 
	FROM
		$from
	WHERE
		$whereList $limit;
END;//
EOF
}

sub parseArg {
	my ($self, $arg) = @_;
	if ($arg =~ m/^([^.]+)\.(.*)$/) {
		return ($1, $2)
	} else {
		return ($self->{self}{name}, $arg)
	}
}

sub argsParser {
	my $self = shift;
	
	for my $argS (@{$self->{argStrings}}) {
		my ($class, $arg) = $self->parseArg($argS);
		unless ($self->{classes}{$class}) {
			$self->{classes}{$class} = []
		}
		push @{$self->{classes}{$class}}, $arg;		
	}
}


sub retParser {
	my $self = shift;
	
	my %rets = ();
	
	for my $retS (@{$self->{return}}) {
		my ($class, $arg) = $self->parseArg($retS);
		$rets{$class} = [] unless $rets{$class};
		push @{$rets{$class}}, $arg;
	}
	
	$self->{'return'} = {%rets};
}

sub joinParser {
	my $self = shift;
	
	my %joins = ();
	
	for my $joinS (@{$self->{join}}) {
		my ($class, $arg) = $self->parseArg($joinS);
		$joins{$class} = [] unless $joins{$class};
		push @{$joins{$class}}, $arg;
	}
	
	$self->{'join'} = {%joins};
	
}

sub updateParser {
	my $self = shift;
	
	my %updates = ();
	
	for my $retS (@{$self->{update}}) {
		my ($class, $arg) = $self->parseArg($retS);
		$updates{$class} = [] unless $updates{$class};
		push @{$updates{$class}}, $arg;
	}
	
	$self->{update} = {%updates};
}

sub resolveArgs {
	my ($self, @classes) = @_;
	
	$self->argsParser;
	$self->retParser;
	$self->joinParser;
	$self->updateParser;
	my %args = ();
		
	for my $c (@classes) {
		# resolve function arguments
		if ($self->{classes}{$c->{name}}) {
			# Loop through our args, and match them to the supplied class args.
			for my $arg (@{$self->{classes}{$c->{name}}}) {
				$args{$arg} = $c->getArg($arg) if $arg ne '*';
			}
		}
		
		# resolve the returns
		if ($self->{'return'}{$c->{name}}) {
			my @list = ();
			RET: for my $r (@{$self->{'return'}{$c->{name}}}) {
				if ($r eq '*') {
					@list = @{$c->{members}};
					last RET;
				}
				else {
					push @list, $c->getArg($r);
				}
			}
			$self->{'return'}{$c->{name}} = [@list];
		}
		
		# resolve the joins
		if ($self->{'join'}{$c->{name}}) {
			my @list = ();
			for my $j (@{$self->{join}{$c->{name}}}) {
				push @list, $c->getArg($j)
			}
			$self->{'join'}{$c->{name}} = [@list];
		}
		
		# resolve the updates
		if ($self->{update}{$c->{name}}) {
			my @list = ();
			for my $j (@{$self->{update}{$c->{name}}}) {
				my $arg = $c->getArg($j);
				push @list, $arg;
				$args{$j} = $arg;
			}
			
			$self->{update}{$c->{name}} = [@list];
		}
	}
	$self->{args} = {%args};
}

1;


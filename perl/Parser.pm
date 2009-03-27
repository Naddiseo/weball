package Parser;

use strict;
use warnings;
use 5.10.0;
use Type;
use Class;
use DBFunction;


use constant {
	kinitial => 1,
	krole => 2,
	ktype => 3,
	kclass => 4,
	kdbfunction => 5,
	kconfig => 6,
};

my $rxIdent = qr/\w[\w\d_-]*/;


sub new {
	my ($class, $file) = @_;
	die 'No input' unless $file;
	
	my $self = {
		types => {},
		state => kinitial,
		classes => {},
		roles => {},
		dbfunctions => {},
		currentClass => '',
		currentType => '',
		currentDBFunction => '',
		tab => 1,
		config => {},
		
		scope => ['ROOT'],
		
		stack => [kinitial],
		
		fh => [],
	};
	
	open my $fh, $file or die $!;
	push @{$self->{fh}}, $fh;
	
	$self = bless $self, $class;
	
	$self->parse;
	
	return $self;
}

sub isKw {
	my ($self, $w) = @_;
	
	my %kw = map { $_ => 1 } qw/roles type class dbfunction config/;
	
	return $kw{$w} and $kw{$w} == 1;
} 


sub newStack {
	my $self = shift;
	$self->{stack} = [kinitial];
	$self->{scope} = ['ROOT'];
	$self->{state} = kinitial;
}

sub pushState {
	my ($self, $state, $name) = @_;
	$self->{debug} && say STDERR "$.: changing to state $state ($name)";
	push @{$self->{stack}}, $state;
	push @{$self->{scope}}, $name;
	$self->{state} = $state;
	
}

sub popStates {
	my ($self, $n) = @_;
	
	if (scalar @{$self->{stack}} > 1) {
		splice @{$self->{stack}}, -$n;
		splice @{$self->{scope}}, -$n;
		$self->{state} = $self->{stack}[$#{$self->{stack}}];
	}
}

sub scope {
	my $self = shift;
	return join('_', @{$self->{scope}});
}

sub getTypes {
	my $self = shift;
	
	return values %{$self->{types}}
}


sub getClasses {
	my $self = shift;
	
	return values %{$self->{classes}}
}

sub getConfig {
	my $self = shift;
	
	return %{$self->{config}}
}


sub getRoles {
	my $self = shift;
	
	return %{$self->{roles}}
}

sub getDBFunctions {
	my $self = shift;
	
	return %{$self->{dbfunctions}};
}

sub getLine {
	my $self = shift;
	my $line = undef;
	while (scalar @{$self->{fh}}) {
		my $fh = $self->{fh}[$#{$self->{fh}}];
		$line = <$fh>;
		unless (defined $line) {
			close $fh;
			pop @{$self->{fh}};
			next;
		}
		last;
	}
	return $line;
}

sub parse {
	my $self = shift;

	while (local $_ = $self->getLine) {
		next if m/^#.*$/;
		chomp;
		s/^(.*)\s*/$1/gi;
		
		if (/^\s*$/) {
			$self->popStates(scalar(@{$self->{stack}}) - 1);
		}
	
		my $t = 0;		
	
		if (/^(\t*)(.*)/) {
			$t = length($1);
			$_ = $2;
		}

		if ($t <= $self->{tab}) {
			$self->popStates($self->{tab} - $t + 1);
			$self->{tab} = $t;
		}
		
		#if (/^($rxIdent)/) {
		#	if ($self->isKw($1)) {
		#		say STDERR "$.: $1 is kw";
		#		$self->newStack;
		#	}
		#}
			
		$self->{debug} && say STDERR "$.:($self->{tab} $t)Stack @{$self->{stack}}";
	
		given ($self->{state}) {
			when (kinitial) {
				$self->sInitial();
				next;
			}
			when (krole) {
				$self->sRole();
				next
			}
			when (ktype) {
				$self->sType();
				next;
			}
			when (kclass) {
				$self->sClass();
				next;
			}			
			when (kdbfunction) {
				$self->sDBFunction();
				next;
			}
			when (kconfig) {
				$self->sConfig();
				next;
			}
		}
	}
	
	# give the functions the info they need
	my %dbfunctions = $self->getDBFunctions;
	my @allclasses = $self->getClasses;
	my $count = @allclasses;

	while (my ($scope, $fn) = each %dbfunctions) {
		$fn->resolveArgs(@allclasses);
	}
	
}

sub sInitial {
	my $self = shift;
	
	given($_) {
		when (/^include\s*\((.*)\)/) {
			open my $fh, $1 or die "File $1 could not be opened: $!";
			push @{$self->{fh}}, $fh;
			return;
		}
		when (/^roles/) {
			$self->pushState(krole, 'role');
			return;
		}
		when (/^class\s+($rxIdent)/) {
			$self->pushState(kclass, "CLASS_$1");
			$self->{currentClass} = $1;
			$self->{classes}{$1} = new Class(name => $1);
			return;
		}
		when (/^type\s+($rxIdent)/) {
			$self->pushState(ktype, "TYPE_$1");
			$self->{currentType} = $1;
			$self->{types}{$1} = new Type(
				name => $1
			);
			return;			
		}
		when (/^dbfunction\s+($rxIdent)\((.*)?\)/) {
			my $fnname = $1;
			my $argList = $2;
			$argList =~ s/\s+//g;
			$self->{currentDBFunction} = $self->scope . $fnname;
			$self->{dbfunctions}{$self->scope . $fnname} = new DBFunction(
				name => $fnname,
				scope => $self->scope,
				argStrings => [split(/,/, $argList)],
				self => {name => ''}
			);
			$self->pushState(kdbfunction, "DBFUNCTION_$fnname");
		}
		when (/^config/) {
			$self->pushState(kconfig, 'config');
			return
		}
	}
}

sub sRole {
	my $self = shift;
	
	given($_) {
		when (/^(\d+)\s($rxIdent)/) {
			$self->{roles}{$1} = $2;
			return;
		}
		when (/^\s*$/) {
			# do nothing
			return;
		}
		default {
			die "Invalid role on line $.";
		}
	}
}

sub sType {
	my $self = shift;
	
	given ($_) {
		when (/^uint|int|string|bool|float|double$/) {
			$self->{types}{$self->{currentType}}->setType($_);
			return;
		}
		when (/^\[(\d+)\]$/) {
			$self->{types}{$self->{currentType}}->setMax($1);
			return
		}
		when (/^\[(\d+):(\d+)\]$/) {
			$self->{types}{$self->{currentType}}->setMin($1);
			$self->{types}{$self->{currentType}}->setMax($2);
			return
		}
		when (/^match rx(.*)$/) {
			$self->{types}{$self->{currentType}}->setMatch($1);
			return
		}
		when (/^default\s*\((.*?)\)$/) {
			$self->{types}{$self->{currentType}}->setDefault($1);
			return;
		}
		when (/^\s*$/) {
			# do nothing
			return;
		}
		default {
			die "Invalid type attribute ($_) on line $.";
		}
	}
}

sub sClass {
	my $self = shift;
	
	my $member = new Type();
	my $isPk = 0;
	my $isIdx = 0;
	my ($name, $type, $match, $max, $min, $default, @traits);
	
	for ($_) {
		# line is all whitespace, or empty
		when (/^\s*$/) {
			# do nothing
			return;
		}
		
		when(/^dbfunction\s+($rxIdent)\((.*)?\)/) {
			my $fnname = $1;
			my $argList = $2;
			$argList =~ s/\s+//g;
			$self->{currentDBFunction} = $self->scope . $fnname;
			$self->{dbfunctions}{$self->scope . $fnname} = new DBFunction(
				name => $fnname,
				scope => $self->scope,
				argStrings => [split(/,/, $argList)],
				self => $self->{classes}{$self->{currentClass}}
			);
			$self->{classes}{$self->{currentClass}}->addDbFunction($self->{dbfunctions}{$self->scope . $fnname});
			$self->pushState(kdbfunction, "DBFUNCTION_$fnname");
			return;
		}
		
		# match primary key
		when (/^pk\((.*)\)$/) {
			$1 =~ s/\s+//g;
			$self->{classes}{$self->{currentClass}}->addPk(split /,/, $1);
			return
		}
		
		# user pkey
		when (/^\@pk\((.*)\)$/) {
			$1 =~ s/\s+//g;
			$self->{classes}{$self->{currentClass}}->addUserPk(split /,/, $1);
			return
		}
		
		# match an index 
		when (/^index\((.*)\)$/) {
			$1 =~ s/\s+//g;
			$self->{classes}{$self->{currentClass}}->addIndex(split /,/, $1);
			return
		}
		
		
		# match the native types
		when (/\G(uint|int|string|bool|float|double)/cgox ) {
			$type = $1;
			redo
		}

		when (/\G\s/cgox) {
			redo
		}
		
		# match db trait auto_increment
		when(/\G(auto_increment)/cgox) {
			push @traits, $1
		}
		
		# match max
		when (/\G\[(\d+)\]/cgox) {
			$max = $1;
			redo
		}
		
		# match min/max
		when (/\G\[(\d+):(\d+)\]/cgox) {
			$min = $1;
			$max = $2;
			redo
		}
		
		# match function
		when(/\Gmatch rx(?<delim>.)(.*?)\k<delim>/cgoix) {
			$match = $1 . $2 . $1;
			redo
		}
		when(/\Gdefault\s*\((.*?)\)/cgoix) {
			$default = $1;
			redo;
		}
		
		# XXX must be next to last so keywords get picked up first
		# match idents, and composite types
		when (/\G($rxIdent)/cgox) {
			if ($self->{types}{$1}) {
				$member->copy($self->{types}{$1});
			} else {
				$name = $1;
			}
			redo
		};
		when(/\G(.*)/cgox) {
			say STDERR "couldn't match $1" if $1;
			last
		}
	}
	
	unless (defined $name) {
		return;
	}
	
	$member->setName($name) if defined $name;
	$member->setMax($max) if defined $max;
	$member->setType($type) if defined $type;
	$member->setMin($min) if defined $min;
	$member->setDefault($default) if defined $default;
	$member->setMatch($match) if defined $match;
	$member->addTraits(@traits) if scalar @traits;
	
	$self->{classes}{$self->{currentClass}}->addMember($member);
	
}

sub sDBFunction {
	my $self = shift;
		
	for ($_) {
		# Updates aren't implemented yet.
		when (/^update\s*\((.*)\)/) {
			my $feild = $1;
			my @feilds = ();
			$feild =~ s/\s+//gi;
			@feilds = split /,/, $feild;
			$self->{dbfunctions}{$self->{currentDBFunction}}->setRetN(1);
			$self->{dbfunctions}{$self->{currentDBFunction}}->setUpdates(@feilds);
		}
		when (/^return(\d+|\*)\s*\((.*)\)/) {
			my $retn = $1;
			my $ret = $2;
			my @rets = ();
			$ret =~ s/\s+//gi;
			@rets = split /,/, $ret;
			$self->{dbfunctions}{$self->{currentDBFunction}}->setRetN($retn);
			$self->{dbfunctions}{$self->{currentDBFunction}}->addReturns(@rets);
			return
		}
		when (/^join\s*\((.*)\)/) {
			my $join = $1;
			my @joins = ();
			$join =~ s/\s+//g;
			@joins = split /,/, $join;
			$self->{dbfunctions}{$self->{currentDBFunction}}->addJoins(@joins);
			return
		}
		last
	}
	
}

sub sConfig {
	my $self = shift;
	
	for ($_) {
		when (/^($rxIdent)\s*\((.*)\)/) {
			$self->{config}{$1} = $2;
		}
	}
}
1;


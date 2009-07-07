#!/usr/bin/perl

use strict;
use warnings;

use 5.010;
use WA;
use Class;
use Member;

my $class = undef;
my $member = undef;
my $function = undef;

my %foreign = ();


open TBL,  ">table.sql" or die $!;
open CRUD, ">crud.sql" or die $!;
open FN, ">functions.sql" or die $!;


sub range {
	my ($min, $max) = @_;
	$member->range($min, $max);
}

sub pk {
	$member->{pk} = shift() ? 2 : 1;
	push @{$class->{pk}}, $member->{name}
}

sub index {
	push @{$class->{indexes}}, [@_]
}

sub auto_increment {
	$member->{auto_increment} = 1
}

sub default {
	$member->{default} = shift;
}

sub email_t {
	$member->{email} = 1
}
sub password_t {
	$member->{password} = 1
}

sub foreign {
	$member->{type} = 'foreign';
	$member->{foreign} = shift;
}

sub local {
	$member->{'local'} = [@_]
}

sub class {
	my $name = shift;
	
	say TBL "DROP TABLE IF EXISTS #db#.$name//";
	say TBL "CREATE TABLE #db#.$name (";
	
	$class = new Class($name);
}

sub member {
	my ($type, $name, $default) = @_;
	$member = new Member($type, $name, $default);

	print TBL "\t`$name` ";
	$class->addMember($member);
}

sub foreign_member {
	my ($type, $name, $default) = @_;
	$member = new Member($name);
	$member->{dbhide} = 1;
	
	$class->addMember($member);
}

sub dbfunction {
	my ($name, @args) = @_;
	my $c = defined $class;
	$name = $c ? "$class->{name}_$name" : $name;
	
	$function = {
		name => $name,
		args => [@args],
		lines => [],
		vars => {},
	};
	
	say FN "DROP PROCEDURE #db#.$name//";
	say FN "CREATE PROCEDURE #db#.$name (";
	
	
}

sub var {
	my ($type, $name, $default) = @_;
	
	member($name);
	eval "&$type();";
	&default($default);
	$function->{vars}{$name} = $member;
	
	say FN "\tDECLARE $name " . sql_getType($member) . sql_getDBAttrs($member) . ';';
}

sub select_into {}
sub return {}

sub sql {
	say FN "\t$_[0];";
}

sub end {
	my $what = shift;
	
	given ($what) {
		when ('class') {
			for my $f (@{$foreign{$class->{name}}}) {
				for my $m (@{$f->{member}}) {
					member("$f->{class}_$m");
					uint();
					end('member');
				}
			}
		
			my @indexes = ();
			# the indexes, and primary keys
			for my $idx (@{$class->{indexes}}) {
				local $" = ',';
				push @indexes, "\tINDEX(@$idx)"
			}
			
			if (@{$class->{pk}}) {
				local $" = ', ';
				push @indexes, "\tPRIMARY KEY(@{$class->{pk}})"
			}
			
			{
				local $, = ",\n";
				say TBL @indexes
			
			}
			
			say TBL ") Engine=InnoDb;//\n";
			sql_c();
			sql_r();
			sql_u();
			sql_d();
			$class = undef;
		}
		when ('member') {
			print TBL sql_getType($member) . sql_getDBAttrs($member);
			say TBL ',';
			$member = undef;
		}
		when ('foreign_member') {
			# do nothing?
			push @{$foreign{$member->{foreign}}}, {
				class => $class->{name},
				member => $member->{'local'}
			};
			$member = undef;
		}
		when ('dbfunction') {
			say FN "END;//\n";
			$function = undef;
		}
	}
}

my @args = ();
my @set = ();
my @where = ();

sub sql_c {
	# create
	say CRUD "DROP PROCEDURE IF EXISTS #db#.create$class->{name}//";
	say CRUD "CREATE PROCEDURE IF EXISTS #db#.create$class->{name} (";
	@args = ();
	for my $arg (@{$class->{members}}) {
		unless ($arg->{pk} == 1 or $arg->{dbhide}) {
			push @args, "\ta_$arg->{name} " . sql_getType($arg)
		}
	}
	say CRUD join(",\n", @args);
	say CRUD ") BEGIN";
	say CRUD "\tINSERT INTO #db#.$class->{name} SET";
	@set = ();
	for my $arg (@{$class->{members}}) {
		unless ($arg->{pk} == 1 or $arg->{dbhide}) {
			push @set, "\t\t`$arg->{name}` = a_$arg->{name}" 
		}
	}
	say CRUD join (",\n", @set) . ';';
	say CRUD "\tSELECT last_insert_id() as retCode;";
	say CRUD "END;//\n";
}

sub sql_r() {
	say CRUD "DROP PROCEDURE IF EXISTS #db#.get$class->{name}//";
	say CRUD "CREATE PROCEDURE IF EXISTS #db#.get$class->{name} (";
	
	@args = ();
	for my $arg (@{$class->{members}}) {
		if ($arg->{pk} and !$arg->{dbhide}) {
			push @args, "\ta_$arg->{name} " . sql_getType($arg)
		}
	}
	say CRUD join(",\n", @args);
	say CRUD ") BEGIN";
	say CRUD "\tSELECT * FROM #db#.$class->{name} WHERE";
	@where = ();
	for my $arg (@{$class->{members}}) {
		if ($arg->{pk} and !$arg->{dbhide}) {
			push @where, "\t\t$class->{name}.$arg->{name} = a_$arg->{name}" 
		}
	}
	print CRUD join (" AND\n", @where)  if scalar @where;
	say CRUD ';';
	say CRUD "END;//\n";
}

sub sql_u() {
	say CRUD "DROP PROCEDURE IF EXISTS #db#.update$class->{name}//";
	say CRUD "CREATE PROCEDURE IF EXISTS #db#.update$class->{name} (";
	@args = ();
	for my $arg (@{$class->{members}}) {
		unless ($arg->{dbhide}) {
			push @args, "\ta_$arg->{name} " . sql_getType($arg)
		}
	}
	say CRUD join(",\n", @args);
	say CRUD ") BEGIN";
	say CRUD "\tUPDATE #db#.$class->{name} SET";
	
	@set = ();
	for my $arg (@{$class->{members}}) {
		unless ($arg->{pk} or $arg->{dbhide}) {
			push @set, "\t\t$class->{name}.`$arg->{name}` = a_$arg->{name}" 
		}
	}
	say CRUD join (",\n", @set);
	say CRUD "\tWHERE";
	
	@where = ();
	for my $arg (@{$class->{members}}) {
		if ($arg->{pk} and !$arg->{dbhide}) {
			push @where, "\t\t$class->{name}.$arg->{name} = a_$arg->{name}" 
		}
	}
	say CRUD join (" AND\n", @where) . ';';
	say CRUD "\tSELECT ROW_COUNT() as retCode;";
	say CRUD "END;//\n";
}

sub sql_d() {
	say CRUD "DROP PROCEDURE IF EXISTS #db#.delete$class->{name}//";
	say CRUD "CREATE PROCEDURE IF EXISTS #db#.delete$class->{name} (";
	@args = ();
	for my $arg (@{$class->{members}}) {
		if ($arg->{pk} and !$arg->{dbhide}) {
			push @args, "\ta_$arg->{name} " . sql_getType($arg)
		}
	}
	say CRUD join(",\n", @args);
	say CRUD ") BEGIN";
	say CRUD "\tDELETE FROM #db#.$class->{name} WHERE";

	@where = ();
	for my $arg (@{$class->{members}}) {
		if ($arg->{pk} and !$arg->{dbhide}) {
			push @where, "\t\t$class->{name}.$arg->{name} = a_$arg->{name}" 
		}
	}
	say CRUD join (" AND\n", @where) . ';';
	say CRUD "\tSELECT ROW_COUNT() as retCode;";
	say CRUD "END;//\n";
}

sub sql_getType {
	my $member = shift;
	my $ret = '';
	
	given ($member->{type}) {
		when ('bool') {
			$ret .= 'TINYINT UNSIGNED';
		}
		when ('uint') {
			my $max = undef;
			my $min = 0;
			
			if ($member->{range}) {
				($min, $max) = @{$member->{range}};
				$min = 0 if $min and $min < 0;
			}
			
			if (defined $max) {
				if ($max <= 255) {
					$ret .= 'TINYINT UNSIGNED'
				}
				elsif ($max <= 65535) {
					$ret .= 'SMALLINT UNSIGNED'
				}
				elsif ($max <= 4294967295) {
					$ret .= 'INT UNSIGNED'
				}
				else {
					$ret .= 'BIGINT UNSIGNED'
				}
			}
			else {
				$ret .= 'INT UNSIGNED'
			}

		}
		
		when ('int') {
			my $max = undef;
			my $min = 0;
			
			if ($member->{range}) {
				($min, $max) = @{$member->{range}};
			}
			
			if (defined $max) {
				if ($max <= 127) {
					$ret .= 'TINYINT'
				}
				elsif ($max <= 32767) {
					$ret .= 'SMALLINT'
				}
				elsif ($max <= 2147483647) {
					$ret .= 'INT'
				}
				else {
					$ret .= 'BIGINT'
				}
			}
			else {
				$ret .= 'INT'
			}
		}
		
		when ('string') {
			my $max = undef;
			my $min = 0;
			
			if ($member->{range}) {
				($min, $max) = @{$member->{range}};
			}
			
			if ($member->{password}) {
				$ret .= 'VARCHAR(32)'
			}
			elsif ($member->{email}) {
				$ret .= 'VARCHAR(100)'
			}
			elsif (defined $max and $max > 2048) {
				$ret .= 'TEXT'
			}
			else {
				$ret .= 'VARCHAR(' . ($max || 1) . ')'
			}
			
		}
		
		when ('float') {
			$ret = 'FLOAT'
		}
	}
	
	return $ret;
}

sub sql_getDBAttrs {
	my $member = shift;
	
	my $ret = '';
	
	given ($member->{type}) {
		when ('bool') {
			$ret = ' NOT NULL DEFAULT ' . ($member->{default} || 0)
		}
		when (/uint|int/) {
			if (!$member->{auto_increment}) {
				$ret = ' NOT NULL DEFAULT ' . ($member->{default} || 0)
			} else  {
				$ret .= ' auto_increment '
			}
		}
		when ('string') {
			$ret = ' NOT NULL DEFAULT "' . ($member->{default} || '') . '"'
		}
		
		when ('float') {
			$ret = ' NOT NULL DEFAULT ' . ($member->{default} || '0.0')
		}
	}

	return $ret;
}

my @context = ();

while (<>) {
	chomp;
	/^\s*(\w+)\s*(.*)$/ and do {
		my @args = WA::parseArgs($2);
		local $" = ', ';
		$_ = "\&$1(@args);";
	};
	
	/^&(class|member|foreign_member|dbfunction)\s*\(/ and do {
		push @context, $1
	};
	/^&end/ and do {
		my $c = pop @context;
		die "No context" unless $c;
		$_ = "&end('$c');";
	};
	say STDERR;
	eval ;
	if ($@) {
		die $@;
	}
}

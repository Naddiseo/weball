package WebAll::SQL;

use strict;
use warnings;

use 5.010;

use File::Path;
use Storable qw/freeze thaw/;

my %functions = ();

my $fnPath = "";
my $procPath = "";
my $tablePath = "";

sub process {
	my $code = shift;
	my %args = @_;
	
	my $libdir = $args{libdir};
	
	$fnPath = "$libdir/sql/functions";
	$procPath = "$libdir/sql/procs";
	$tablePath = "$libdir/sql/tables";
	
	mkpath(
		$fnPath,
		$procPath,
		$tablePath
	);
	
	processClasses($code->{classes});
}

sub processClasses {
	my $classes = shift;
	
	
	for my $classN (keys %$classes) {
		my $class = $classes->{$classN};
		
		
		open my $tblFH, ">$tablePath/$classN.sql" or die $!;
		
		say $tblFH "DROP TABLE IF EXISTS #db#.$classN//";
		say $tblFH "CREATE TABLE #db#.$classN (";
		
		my @members = ();
		
		for my $member (@{$class->{members}}) {
			push @members, getMemberSQL(@$member);
		}
		
		if ($class->{pk}) {
			my @pkList = ();
			for my $ival (@{$class->{pk}}) {
				if ($ival->[0] eq $classN) {
					push @pkList, $ival->[1]
				}
			}
			push @members, "\tPRIMARY KEY (" . join(', ', @pkList) . ')'
		}
		
		for my $idx (@{$class->{indexes}}) {
			my @idxList = ();
			for my $ival (@$idx) {
				if ($ival->[0] eq $classN) {
					push @idxList, $ival->[1]
				}
			}
			if (scalar @idxList) {
				push @members, "\tINDEX (" . join(', ', @idxList) . ')'
			}
		}
		
		say $tblFH join(",\n", @members);
		
		say $tblFH ") Engine=InnoDb;//";
		
		close $tblFH;
		
		open my $crudFH, ">$procPath/$classN.sql" or die $!;
		
		my @args = ();
		my @set = ();
		my @where = ();
		
		# create
		say $crudFH "DROP PROCEDURE IF EXISTS #db#.create$classN//";
		say $crudFH "CREATE PROCEDURE IF EXISTS #db#.create$classN (";
		@args = ();
		for my $arg (@{$class->{members}}) {
			unless ($arg->[1]{pk}) {
				push @args, "\ta_$arg->[0] " . getSQLType($arg->[1])
			}
		}
		say $crudFH join(",\n", @args);
		say $crudFH ") BEGIN";
		say $crudFH "\tINSERT INTO #db#.$classN SET";
		@set = ();
		for my $arg (@{$class->{members}}) {
			unless ($arg->[1]{pk}) {
				push @set, "\t\t`$arg->[0]` = a_$arg->[0]" 
			}
		}
		say $crudFH join (",\n", @set) . ';';
		say $crudFH "\tSELECT last_insert_id() as retCode;";
		say $crudFH "END;//\n";
		
		# read
		say $crudFH "DROP PROCEDURE IF EXISTS #db#.get$classN//";
		say $crudFH "CREATE PROCEDURE IF EXISTS #db#.get$classN (";
		@args = ();
		for my $arg (@{$class->{members}}) {
			if ($arg->[1]{pk}) {
				push @args, "\ta_$arg->[0] " . getSQLType($arg->[1])
			}
		}
		say $crudFH join(",\n", @args);
		say $crudFH ") BEGIN";
		say $crudFH "\tSELECT * FROM #db#.$classN WHERE";
		@where = ();
		for my $arg (@{$class->{members}}) {
			if ($arg->[1]{pk}) {
				push @where, "\t\t$classN.$arg->[0] = a_$arg->[0]" 
			}
		}
		say $crudFH join (" AND\n", @where) . ';';
		say $crudFH "END;//\n";
		
		# update
		say $crudFH "DROP PROCEDURE IF EXISTS #db#.update$classN//";
		say $crudFH "CREATE PROCEDURE IF EXISTS #db#.update$classN (";
		@args = ();
		for my $arg (@{$class->{members}}) {
			push @args, "\ta_$arg->[0] " . getSQLType($arg->[1])
		}
		say $crudFH join(",\n", @args);
		say $crudFH ") BEGIN";
		say $crudFH "\tUPDATE #db#.$classN SET";
		
		@set = ();
		for my $arg (@{$class->{members}}) {
			unless ($arg->[1]{pk}) {
				push @set, "\t\t$classN.`$arg->[0]` = a_$arg->[0]" 
			}
		}
		say $crudFH join (",\n", @set);
		say $crudFH "\tWHERE";
		
		@where = ();
		for my $arg (@{$class->{members}}) {
			if ($arg->[1]{pk}) {
				push @where, "\t\t$classN.$arg->[0] = a_$arg->[0]" 
			}
		}
		say $crudFH join (" AND\n", @where) . ';';
		say $crudFH "\tSELECT ROW_COUNT() as retCode;";
		say $crudFH "END;//\n";
		
		# update
		say $crudFH "DROP PROCEDURE IF EXISTS #db#.delete$classN//";
		say $crudFH "CREATE PROCEDURE IF EXISTS #db#.delete$classN (";
		@args = ();
		for my $arg (@{$class->{members}}) {
			if ($arg->[1]{pk}) {
				push @args, "\ta_$arg->[0] " . getSQLType($arg->[1])
			}
		}
		say $crudFH join(",\n", @args);
		say $crudFH ") BEGIN";
		say $crudFH "\tDELETE FROM #db#.$classN WHERE";

		@where = ();
		for my $arg (@{$class->{members}}) {
			if ($arg->[1]{pk}) {
				push @where, "\t\t$classN.$arg->[0] = a_$arg->[0]" 
			}
		}
		say $crudFH join (" AND\n", @where) . ';';
		say $crudFH "\tSELECT ROW_COUNT() as retCode;";
		say $crudFH "END;//\n";
		
		close $crudFH;
	}
	
}

sub getMemberSQL {
	my ($name, $member) = @_;
	
	my $ret = "\t`$name` " . getSQLType($member);
	
	given ($member->{type}) {
		when ('bool') {
			if (defined $member->{default}) {
				$ret .= ' NOT NULL DEFAULT ' . $member->{defualt}
			}
		}
		when ('uint') {
			unless ($member->{auto_increment} and defined $member->{default}) {
				$ret .= ' NOT NULL DEFAULT ' . $member->{default}
			}
			
			if ($member->{auto_increment}) {
				$ret .= ' auto_increment '
			}
		}
		
		when ('int') {
			unless ($member->{auto_increment} and defined $member->{default}) {
				$ret .= ' NOT NULL DEFAULT ' . $member->{default}
			}
			
			if ($member->{auto_increment}) {
				$ret .= ' auto_increment '
			}
		}
		
		when ('string') {
			
			if (defined $member->{default}) {
				$ret .= ' NOT NULL DEFAULT "' . $member->{default} . '"'
			}
		}
	}

	return $ret;
}

sub getSQLType {
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
				$min = 0 if $min < 0;
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
	}
	
	return $ret;
}

1;

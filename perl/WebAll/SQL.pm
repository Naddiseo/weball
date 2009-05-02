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
		
		for my $memberN (keys %{$class->{members}}) {
			push @members, getMemberSQL($memberN, $class->{members}{$memberN});
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
			push @members, "\tINDEX (" . join(', ', @idxList) . ')'
		}
		
		say $tblFH join(",\n", @members);
		
		say $tblFH ");";
		
		close $tblFH;
	}
	
}

sub getMemberSQL {
	my ($name, $member) = @_;
	
	my $ret = "\t`$name` ";
	
	given ($member->{type}) {
		when ('bool') {
			$ret .= 'TINYINT UNSIGNED';
			if (defined $member->{default}) {
				$ret .= ' NOT NULL DEFAULT ' . $member->{defualt}
			}
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
		
			unless ($member->{auto_increment} and defined $member->{default}) {
				$ret .= ' NOT NULL DEFAULT ' . $member->{default}
			}
			
			if ($member->{auto_increment}) {
				$ret .= ' auto_increment '
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
		
			unless ($member->{auto_increment} and defined $member->{default}) {
				$ret .= ' NOT NULL DEFAULT ' . $member->{default}
			}
			
			if ($member->{auto_increment}) {
				$ret .= ' auto_increment '
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
			
			if (defined $member->{default}) {
				$ret .= ' NOT NULL DEFAULT "' . $member->{default} . '"'
			}
		}
	}

	return $ret;
}




1;

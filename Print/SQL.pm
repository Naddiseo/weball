package Print::SQL;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

our $VERSION = 2010.06.18;
our $OUTDIR = '';

use AST::Template;
use AST::Template::Node;
use AST::Primitive;

sub print {
	my ($c, $tree) = @_;

	die "Not class" unless ref $tree eq 'Symbol::ClassSymbol';
	my $filename = $tree->getSymbolEntryName();
	

	my $output = "$OUTDIR/$filename.sql";
	
	open my $FH, ">$output" or die "Error opening '$output': $!";
	
	printCreate($tree, $FH);
	
	if ($tree->hasAttr('base')) {
		my $crud = $tree->getAttr('base')->getArg(0)->value;
		

		printFNCreate($tree, $FH) if (index $crud, 'c');
		printFNRead($tree, $FH) if (index $crud, 'r');
		printFNUpdate($tree, $FH) if (index $crud, 'u');
		printFNDelete($tree, $FH) if (index $crud, 'd');

		
	}
	
	close $FH;
	
}

sub printFNCreate {}
sub printFNRead {}
sub printFNUpdate {}
sub printFNDelete {}

sub printCreate {
	my ($tree, $FH) = @_;
	
	my $filename = $tree->getSymbolEntryName();
	my $engine = getEngine($tree);
	my $pk     = getPK($tree);
	my @idx    = getIndexes($tree);
	my @vars   = getVars($tree);
	
	say $FH "CREATE TABLE IF NOT EXISTS #db#.`$filename` (";

	while (@vars) {
		my $var = shift @vars;
		my $name = $var->getSymbolEntryName();
		my $type = getDBType($var);
		my $str  = "\t`$name` $type NOT NULL";
		
		if ($var->hasAttr('auto_increment')) {
			$str .= ' AUTO_INCREMENT';
		}
		
		if ($var->hasAttr('default')) {
			$str .= ' DEFAULT ' . quoteDBValue($var->getAttr('default'));
		}
		
		if ($pk or scalar(@idx) > 0 or scalar(@vars) > 0) {
			$str .= ',';
		}
		
		say $FH $str;
	}

	while (@idx) {
		my @keys = @{shift @idx};
		my $str = "\tINDEX (`". join('`, `', @keys) . '`)' if scalar @keys;
		
		if ($pk or scalar(@idx) > 0) {
			$str .= ',';
		}
		
		say $FH $str;
	}
	say $FH "\t$pk" if $pk;
	say $FH ") Engine = $engine CHARACTER SET utf8 COLLATE utf8_unicode_ci;//";
} 

sub getVars {
	my ($tree) = @_;
	
	my @ret = ();
	
	for (my $i = 0; $i < $tree->getVarCount(); $i++) {
		my $k = $tree->{varorder}[$i];
		my $v = $tree->{vars}{$k};
		push @ret, $v;

	}
	
	return @ret;
}

sub getEngine {
	my ($tree) = @_;
	
	my $ret = 'InnoDB';
	
	if ($tree->hasAttr('engine')) {
		$ret = $tree->getAttr('engine')->getArg(0)->value;
	}
	return $ret;
}

sub getPK {
	my ($tree) = @_;
	
	my $ret = '';
	
	if ($tree->hasAttr('pk')) {
		my $pk = $tree->getAttr('pk');
		my @keys = ();
		
		for (my $i = 0; $i < $pk->getArgc(); $i++) {
			push @keys, $pk->getArg($i)->value;
		}
		
		if (scalar @keys) {
			$ret = 'PRIMARY KEY(`' . join('`, `', @keys) . '`)';
		}
	
	}
	
	return $ret;
}

sub getIndexes {
	my ($tree) = @_;
	
	my @ret = ();
	# TODO: support more than one index
	
	if ($tree->hasAttr('index')) {
		my $idx = $tree->getAttr('index');
		my @keys = ();
		
		for (my $i = 0; $i < $idx->getArgc(); $i++) {
			push @keys, $idx->getArg($i)->value;
		}
		push @ret, [@keys];
	}
	
	return @ret;
}

sub getDBType{
	my ($type) = @_;
	my $ret = 'TEXT';
	
	my ($min, $max) = (0, 0);
	if ($type->hasAttr('range')) {			
		($min, $max) = $type->getAttr('range')->getArg(0, 1);
		
		$min = $min->value;
		$max = $max->value;
		
		$min = 0 unless defined ($min);
		$max = 0 unless defined ($max) and $max > 0;
	}
	
	given ($type->getType()->getName()) {
		when ('bool') {
			$ret = 'TINYINT UNSIGNED';
		}
		when ('double') {
			$ret = 'DOUBLE';
		}
		when ('int') {
			given ($max) {
				when($_ >= -128 and $_ <= 127) {
					$ret = 'TINYINT';
				}
				when ($_ >= -32768 and $_ <= 32767) {
					$ret = 'SMALLINT';
				}
				when ($_ >= -8388608 and $_<= 8388607) {
					$ret = 'MEDIUMINT';
				}
				when ($_ >= -2147483648 and $_ <= 2147483647) {
					$ret = 'INTEGER';
				}
				default {
					$ret = 'INTEGER';
				}
			}
			
			$ret = 'TINYINT' if ($type->hasAttr('tiny'));
			$ret = 'SMALLINT' if ($type->hasAttr('small'));
			$ret = 'MEDIUMINT' if ($type->hasAttr('medium'));
			$ret = 'BIGINT' if ($type->hasAttr('big'));
			
		}
		when ('string') {
			$max = 1 if $max < 1;
			
			$ret = "VARCHAR($max)";
			
			$ret = 'VARCHAR(10)' if ($type->hasAttr('tiny'));
			$ret = 'VARCHAR(50)' if ($type->hasAttr('small'));
			$ret = 'VARCHAR(255)' if ($type->hasAttr('medium'));
			$ret = 'TEXT' if ($type->hasAttr('big') or $max > 65535);
		}
		when ('uint') {
			given ($max) {
				when($_ >= 0 and $_ <= 255) {
					$ret = 'TINYINT';
				}
				when ($_ >= 0 and $_ <= 65535) {
					$ret = 'SMALLINT';
				}
				when ($_ >= 0 and $_<= 16777215) {
					$ret = 'MEDIUMINT';
				}
				when ($_ >= 0 and $_ <= 4294967295) {
					$ret = 'INTEGER';
				}
				default {
					$ret = 'INTEGER';
				}
			}
			
			$ret = 'TINYINT' if ($type->hasAttr('tiny'));
			$ret = 'SMALLINT' if ($type->hasAttr('small'));
			$ret = 'MEDIUMINT' if ($type->hasAttr('medium'));
			$ret = 'BIGINT' if ($type->hasAttr('big'));
		}
		when (/null|undef/ or 'unresolved' or 'ptr') {
			carp "Trying to get db type from '$_'";
		}
	}
	
	return $ret ;
}

sub quoteDBValue {
	my ($var) = @_;
	
	my $ret = '';
	
	if ($var->getArgc() == 1) {
		$ret = $var->getArg(0)->value();

		given ($var->getType()->getName()) {
			when (/int/) {}
			when (/string/) {
				$ret =~ s/\\/\\\\/g;
				$ret =~ s/"/\\"/g;
				$ret = '"' . $ret . '"';
			}
			default {
				carp "Don't know what type '$_' is for DBQuote"
			}
		}
	}
	else {
		carp "Can't quote arrays";
	}
	
	return $ret;
}

1;
__END__

=head1 NAME



=head1 SYNOPSYS



=head1 DESCRIPTION



=head1 EXAMPLE



=head1 LICENSE

Copyright (C) 2010 Richard Eames.
This module may be modified, used, copied, and redistributed at your own risk.
Publicly redistributed modified versions must use a different name.

package WebAll::SymbolTable;

use strict;
use warnings;

use 5.010;

use Exporter;

our @EXPORT_OK = qw(
	sym_getType sym_newType
);

our $VERSION = '2.0.0';

my %types = (
	'INT' => {},
	'UINT' => {},
	'FLOAT' => {},
	'STRING' => {},
	'BOOL' => {},
);

sub sym_error {
	my $message = shift;
	
	die "SymbolTable: $message\n"
}

sub sym_getType {
	my $name = shift;
	
	unless (typeExists($name)) {
		error ("Unknown type $name")
	}
	
	return $WebAll::SymbolTable::types{$name}
}

sub sym_typeExists {
	my $name = shift;
	
	return exists $WebAll::SymbolTable::types{$name}
}

sub sym_newType {
	my ($name, $copy, %newAttrs) = @_;
	
	if (sym_typeExists($name)) {
		error ("Type $name is redefined")
	}
	
	my %attrs = ();
	
	# Copy the attributes from the original
	if ($copy) {
		%attrs = %{sym_getType($copy)};
	}
	
	# Overwrite attributes with the supplied
	while (my ($k, $v) = each %newAttrs) {
		$attrs{$k} = $v;
	}
	
	$WebAll::SymbolTable::types{$name} = {%attrs};
}
1;

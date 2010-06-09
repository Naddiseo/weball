package Analysis::Class;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

our $VERSION = 2010.06.08;

use Symbol::AttributeSymbol;
use Symbol::ClassSymbol;
use Symbol::FunctionSymbol;
use Symbol::VariableSymbol;

use Analysis::Attribute;
use Analysis::Function;
use Analysis::Variable;

sub new { carp __PACKAGE__ . ' does have new()'; }


sub analyse {
	my ($classSym) = @_;
	
	my $ast = $classSym->{ast};
	delete $classSym->{ast};
	
	while (my ($varname, $var) = each %{$ast->{vars}}) {
		my $varSym = Symbol::VariableSymbol->new($var);
		$classSym->{scope}->define($varSym->getSymbolEntryName(), $varSym);
		Analysis::Variable::analyse($varSym);
	}
	
	while (my ($attrname, $attr) = each %{$ast->{attrs}}) {
		my $attrSym = Symbol::AttributeSymbol->new($attr);
		Analysis::Attribute::analyse($attrSym);
		$classSym->addAttr($attrSym->getSymbolEntryName(), $attrSym);
	}
	
	
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

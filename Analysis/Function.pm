package Analysis::Function;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

our $VERSION = 2010.06.12;

use Analysis::Attribute;
use Analysis::Stmt;
use Analysis::Variable;

use Symbol::AttributeSymbol;
use Symbol::VariableSymbol;
use Symbol::Type;
use Symbol::TypeFactory;


sub new { carp __PACKAGE__ . ' does have new()'; }


sub analyse {
	my ($fnSym) = @_;
	
	
	if( ref $fnSym->{ast}{argv} ne 'ARRAY') {
		croak "ast->argv is not an array\n". Dumper $fnSym, ref($fnSym->{ast}{argv});
	}
	
	my $ast = $fnSym->{ast};
	delete $fnSym->{ast};
	
	$fnSym->{argc} = scalar @{$ast->{argv}};
	
	for my $arg (@{$ast->{argv}}) {
		my $variableSym = Symbol::VariableSymbol->new($arg);
		$variableSym->setScope($fnSym->getScope());
		
		Analysis::Variable::analyse($variableSym);

		my $type = Symbol::Type::getTypeFromPrimitive($arg);
		
		$variableSym->setType($type);
		
		push @{$fnSym->{argv}}, $variableSym;
	}
	
	
	#die Dumper($ast);
	
	while (my ($attrname, $attr) = each %{$ast->{attrs}}) {
		my $attrSym = Symbol::AttributeSymbol->new($attr);
		Analysis::Attribute::analyse($attrSym);
		$fnSym->addAttr($attrSym->getSymbolEntryName(), $attrSym);
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

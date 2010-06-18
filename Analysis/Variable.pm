package Analysis::Variable;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

our $VERSION = 2010.06.18;

use Eval::Eval;
use Symbol::VariableSymbol;

sub new { carp __PACKAGE__ . ' does have new()'; }


sub analyse {
	my ($varSym) = @_;
	
	my $ast = $varSym->{ast};
	delete $varSym->{ast};
	
	# XXX: check to see if this is a valid assumption
	$varSym->{scope}{enclosing} = $varSym->{scope}->getParentScope();
	
	given ($ast->{type}) {
		when ('bool') {
			$varSym->setType('Bool');
		}
		when ('double') {
			$varSym->setType('Double');
		}
		when ('int') {
			$varSym->setType('Int');
		}
		when ('string') {
			$varSym->setType('String');
		}
		when ('uint') {
			$varSym->setType('UInt');
		}
		when ('null') {
			$varSym->setType('Undef');
		}
		default {
			$varSym->setType('Unresolved');
		}
		
	
	}
	
	
	while (my ($attrname, $attr) = each %{$ast->{attrs}}) {
		my $attrSym = Symbol::AttributeSymbol->new($attr);
		Analysis::Attribute::analyse($attrSym);
		
		if ($attrname eq 'default') {
			$attrSym->setType($ast->{type});
		}
		
		$varSym->addAttr($attrSym->getSymbolEntryName(), $attrSym);
	}

	
	#die Dumper($varSym, $ast);
	
	
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

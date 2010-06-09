package Analysis::Variable;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.08;

use Eval::Eval;
use Symbol::VariableSymbol;

sub new { carp __PACKAGE__ . ' does have new()'; }


sub analyse {
	my ($varSym) = @_;
	
	my $ast = $varSym->{ast};
	delete $varSym->{ast};
	
	# XXX: check to see if this is a valid assumption
	$varSym->{scope}{enclosing} = $varSym->{scope}->getParentScope();
	
	
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

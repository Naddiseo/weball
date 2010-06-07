package AST::Stmt::If;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.21;

use AST::Block;
use AST::Expr;

sub new {
	my ($c, $cond, $block, $elseifs, $else) = @_;
	
	
	$block   = AST::Block->new() unless defined $block;
	$elseifs = []                unless defined $elseifs;
	$else    = AST::Block->new() unless defined $else;
	
	my $self = {
		cond    => $cond,
		block   => $block,
		elseifs => $elseifs,
		'else'  => $else
	};
	
	bless $self => $c;
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

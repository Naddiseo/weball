package AST::Stmt::For;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.22;

use AST::Block;
use AST::Expr;
use AST::Primitive;

sub new {
	my ($c, $var, $cond, $inc, $block) = @_;
	
	my $tok = Token->new({},'bool', 'true');
	
	$var   = AST::Expr->new()                  unless defined $var;
	$cond  = AST::Primitive->new('bool', $tok) unless defined $cond;
	$block = AST::Block->new()                 unless defined $block;
	$inc   = AST::Block->new()                 unless defined $inc;
	
	my $self = {
		var   => $var,
		cond  => $cond,
		inc   => $inc,
		block => $block
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

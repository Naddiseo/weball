package AST::Expr;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.06;

sub new {
	my ($c, $block) = @_;
	
	$block = AST::Block->new() unless defined $block;
	
	my $self = {
		block => $block,
		type  => 'expr_block',
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

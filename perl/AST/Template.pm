package AST::Template;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.25;

use AST::Attr;
use AST::Template::Node;

sub new {
	my ($c, $ident, $attrs, $stmts) = @_;
	
	$attrs = [] unless defined $attrs;
	$stmts = [] unless defined $stmts;
	
	
	my $self = {
		name  => $ident->value,
		attr  => {},
		stmts => $stmts,
	};
	
	for my $attr (@{$attrs}) {
		$self->{attr}{$attr->getName()} = $attr;
	}
	
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

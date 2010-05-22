package AST::Math::Add;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.22;

sub new {
	my ($c, $lhs, $rhs) = @_;
	
	my $self = {
		op  => '+',
		lhs => $lhs,
		rhs => $rhs
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

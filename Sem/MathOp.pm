package Sem::MathOp;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.05;

use Sem::Temp;

sub new {
	my ($c, $op, $lhs, $rhs) = @_;
	
	my $self = {
		op  => $op,
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

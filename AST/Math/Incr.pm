package AST::Math::Incr;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.06;

sub new {
	my ($c, $isPre, $expr) = @_;
	
	my $self = {
		pre  => ($isPre ? 1 : 0),
		expr => $expr,
		type => 'int',
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

package AST::Primitive;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.15;

sub new {
	my ($c, $type, $token) = @_;
	
	my $self = {
		type  => $type,
		token => $token,
		value => $token->{value},
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

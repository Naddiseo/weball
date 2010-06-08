package Symbol::Type::UInt;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use base qw/Symbol::Type/;

our $VERSION = 2010.06.07;

sub new {
	my ($c) = @_;
	
	my $self = $c->SUPER::new('uint', 0);
	
	return $self;
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

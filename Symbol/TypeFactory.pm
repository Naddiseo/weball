package Symbol::TypeFactory;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.07;

use Symbol::Type;

sub new {
	carp __PACKAGE__ . " does have new()"
}

sub createType {
	my ($type, @args) = @_;

	my $package = 'Symbol::Type::' . ucfirst($type);
	require $package;
	
	return $package->new(@args);
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

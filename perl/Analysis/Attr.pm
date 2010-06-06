package Analysis::Attr;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.26;

sub new {
	my ($c, $ident, $arglist) = @_;
	
	$arglist = [] unless defined $arglist;
	
	my $self = {
		name  => $ident->{value},
		args  => $arglist
	};
	
	bless $self => $c;
}

sub getName {
	my ($self) = @_;
	
	return $self->{name};
}

sub getArg {
	my ($self, $n) = @_;
	$n = 0 unless defined $n;
	return @{$self->{argList}}[$n];
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

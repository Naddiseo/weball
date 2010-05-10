package AST::Ident;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.10;

sub new {
	my ($c, $ident) = @_;
	
	my $self = {
		fq    => '',
		parts => [],
		ident => $ident
	};
	
	$self->{fq} = $ident->{value};

	bless $self => $c;
}


sub addPart {
	my ($self, $ident) = @_;

	$self->{fq} .= '::' . $ident->{ident}{value} ;

	push @{$self->{parts}}, $ident;
	$self;
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
package AST::Ident;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.06;

sub new {
	my ($c, $ident, $isLocal) = @_;
	
	my $self = {
		fq        => '',
		parts     => [],
		ident     => $ident,
		localName => $ident->{value},
		isLocal   => ($isLocal or 0),
		# TODO: go lookup in the symbol table what type this is
		type      => 'variable',
	};
	
	$self->{fq} = $ident->{value};
	
	unshift @{$self->{parts}}, $self->{fq};

	bless $self => $c;
}

sub getLocalName {
	my ($self) = @_;
	return $self->{localName};
}

sub getFqName {
	my ($self) = @_;
	
	my @fq = ($self->getLocalName());	
	
	
	for my $part (@{$self->{parts}}) {
		if (ref $part eq 'AST::Ident') {
			unshift @fq, $part
			#$fq .= '.' . $part->{ident}{value};
		}
		else {
			
		}
	}
	
	return join '.', @{$self->{parts}};
}


sub addPart {
	my ($self, @idents) = @_;

	
	for my $ident (@idents) {
		if (ref $ident eq 'AST::Ident') {
			unshift @{$self->{parts}}, $ident->getLocalName();
		}
		else {
			unshift @{$self->{parts}}, $ident;
		}
	}
	
	

	#unshift @{$self->{parts}}, $ident;
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

package Symbol::AttributeSymbol;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

use base qw/Symbol::SymbolEntry/;

our $VERSION = 2010.06.18;

sub new {
	my ($c, $ast) = @_;
	
	my $self = $c->SUPER::new($ast->{name}, undef, $ast);
	
	$self->{argc} = 0;
	$self->{argv} = [];
	
	return $self;
}

sub getArgc {
	my ($self) = @_;
	return $self->{argc};
}

sub getArg {
	my ($self, @n) = @_;
	
	my @ret = ();
	
	for my $i (@n) {
		if ($i < 0 or $i > $self->getArgc()) {
			croak "Arg Number is too high or < 0"
		}
		
		push @ret, $self->{argv}[$i];
	}
	
	
	
	return wantarray ? @ret : $ret[0];
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

package Sem::Temp;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.05;

sub new {
	my ($c) = @_;
	
	state $tmpnum = 0;
	
	my $self = {
		id   => ++$tmpnum,
		expr => undef,
	};
	
	bless $self => $c;
}

sub id {
	my ($self) = @_;
	return $self->{id};
}

sub assign {
	my ($self, $expr) = @_;
	$self->{expr} = $expr;
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

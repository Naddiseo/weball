package AST::FNCall;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.06;

sub new {
	my ($c, $name, $args) = @_;
	
	$args = [] unless defined $args;
	
	my $self = {
		name => $name,
		args => $args,
		# TODO: get type of this
		type => 'function_call'
	};
	
	bless $self => $c;
}

sub addArg {
	my ($self, $arg) = @_;

	push @{$self->{args}}, $arg
}

sub getName {
	my ($self) = @_;
	
	return $self->{name}->getFqName();
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

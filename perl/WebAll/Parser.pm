package WebAll::Parser;

use strict;
use warnings;

use 5.010;

use Data::Dumper;

our $VERSION = '2.0.0';

sub new {
	my ($c, $lexer) = @_;
	$c = ref $c || $c;
	
	my $self = {
		lex => $lexer,
		look => undef,
		peek => undef,
	};
	
	bless $self => $c;	
}

sub next {
	my $self = shift;
	
	$self->look
}

sub error {
	my ($self, $msg) = @_;
	
	my ($line, $char) = @{$self->{look}}[2,3];
	
	die "Parse error [$line : $char]: $msg\n"
	
}

sub expect {
	my ($self, $t) = @_;
	
	$self->error("Expected $t, got $self->{look}[0]")
}



1;

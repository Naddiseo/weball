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

sub next {}
sub error {}
sub expect {}



1;

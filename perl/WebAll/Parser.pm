package WebAll::Parser;

use strict;
use warnings;

use 5.010;

our $VERSION = '2.0.0';

sub new {
	my ($c, $lexer) = @_;
	$c = ref $c || $c;
	
	my $self = {
	
	};
	
	bless $self => $c;	
}

1;

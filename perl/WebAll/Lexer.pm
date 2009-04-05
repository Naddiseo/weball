package WebAll::Lexer;

use strict;
use warnings;

use 5.010;

our $VERSION = '2.0.0';

sub new {
	my ($c, $file) = @_;
	$c = ref $c || $c;
	
	my $self = {
		text => [],
		lineN => 0,
		lastLineLength => 0,
	};
	
	bless $self => $c;
}

sub yylex {
	
}

1;

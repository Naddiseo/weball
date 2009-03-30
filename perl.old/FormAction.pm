package FormAction;

use strict;
use warnings;
use feature ':5.10';

use Form;
use Type;

sub new {
	my ($c, %args) = @_;
	
	my $self = {
		name => $args{formName},
		form => undef,
		
	};
	
	bless $self, $c;	
}


1;

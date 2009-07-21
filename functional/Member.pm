package Member;

use strict;
use warnings;

sub new {
	my ($c, $type, $name, $default) = @_;
	
	my $self = {
		name => $name,
		type => $type,
		max => 0,
		min => 0,
		pk => 0,
		default => $default,
		dbhide => 0,
	};

	bless $self, $c;
}

sub range {
	my ($self, $min, $max) = @_;
	$self->{max} = $max || 0;
	$self->{min} = $min || 0;
}

1;

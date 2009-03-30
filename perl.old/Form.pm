package Form;

use strict;
use warnings;
use 5.10.0;
use Type;

sub new {
	my ($c, %args) = @_;
	$c = ref $c if ref $c;
	
	my $self = {
		name => $args{name},
		method => $args{method},
		fields => [],
	};
	
	bless $self => $c
}

sub addField {
	my ($self, $f) = @_;
	
	push @{$self->{fields}}, $f
}

sub phpFilterArgs {
	my $self = shift;
	
	my @rv = ();
	
	for my $f (@{$self->{fields}}) {
		my $filt = $f->phpFilter;
		push @rv, "'$f->{name}' => $filt,\n";
	}
	
	return @rv;
}

1

package Page;

use strict;
use warnings;
use 5.10.0;
use Type;
use Form;

sub new {
	my ($c, %args) = @_;
	$c = ref $c if ref $c;
	
	my $self = {
		name => $args{name},
		forms => [],
		privacy => ($args{privacy} || 'public'),
		'use' => ($args{'use'} || []),
		title => '',
	};
	
	bless $self => $c
}

sub addForm {
	my ($self, $form) = @_;
	
	push @{$self->{forms}}, $form;
}

sub setPrivacy {
	my ($self, $p) = @_;
	
	$self->{privacy} = $p;
}

sub addUse {
	my ($self, $u) = @_;
	
	push @{$self->{use}}, $u
}

sub setTitle {
	my ($self, $t) = @_;
	
	$self->{title} = $t;
}	

sub phpUse {
	my $self = shift;
	
	my $rv = '';
	
	for my $r (@{$self->{use}}) {
		$rv .= "require_once('dbinterface/$r.php');\n";
	}
	
	return $rv;
}

sub phpGet {
	my $self = shift;
	
	my @rv = ();
	
	for my $f (@{$self->{forms}}) {
		if ($f->{method} eq 'get') {
			push @rv, $f->phpFilterArgs;
		}
	}
	
	return @rv
}

sub phpPost {
	my $self = shift;
	
	my @rv = ();
	
	for my $f (@{$self->{forms}}) {
		if ($f->{method} eq 'post') {
			push @rv, $f->phpFilterArgs;
		}
	}
	return @rv
}

1;

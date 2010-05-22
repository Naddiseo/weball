package AST::Var;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use AST::Attr;
use Data::Dumper;

our $VERSION = 2010.05.21;

sub new {
	my ($c, $type, $ident, $attrs, $default) = @_;
	
	
	#die(Dumper(@_));
	my $self = {
		name  => $ident,
		type  => $type,
		attr  => {}
	};
	
	if (defined $attrs) {
		#die (Dumper($type, $ident, $attrs));
		for my $attr (@{$attrs}) {
			$self->{attr}{$attr->getName()} = $attr;
		}
	}
	
	if (defined $default) {
		$self->{attr}{default} = $default;
	}
	
	bless $self => $c;
}

sub getName {
	my ($self) = @_;
	
	return $self->{name}{value};
}

sub addAttr {
	my ($self, $a) = @_;

	if ($self->{attr}{$a->{name}}) {
		carp "Var $self->{name} already has attribute $a->{name}";
	}

	$self->{attr}{$a->{name}} = $a;
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

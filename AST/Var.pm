package AST::Var;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

use AST::Attr;

our $VERSION = 2010.06.06;

sub new {
	my ($c, $type, $ident, $attrs, $default) = @_;

	my $self = {
		name  => $ident,
		type  => $type,
		attrs  => {}
	};
	
	if (defined $attrs) {
		#die (Dumper($type, $ident, $attrs));
		for my $attr (@{$attrs}) {
			$self->{attrs}{$attr->getName()} = $attr;
		}
	}
	
	if (defined $default) {
		$self->{attrs}{default} = $default;
	}
	
	bless $self => $c;
}

sub getLocalName {
	my ($self) = @_;
	
	return $self->{name}->getLocalName();
}

sub getFqName {
	my ($self) = @_;
	
	return  $self->{name}->getFqName();
}


sub addAttr {
	my ($self, $a) = @_;

	if ($self->{attrs}{$a->{name}}) {
		carp "Var $self->{name} already has attribute $a->{name}";
	}

	$self->{attrs}{$a->{name}} = $a;
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

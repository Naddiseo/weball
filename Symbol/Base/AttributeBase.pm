package Symbol::Base::AttributeBase;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.18;

use AST::Ident;

sub hasAttr {
	my ($self, $name) = @_;
	return exists $self->{attrs}{$name};
}

sub getAttr {
	my ($self, $name) = @_;
	return ($self->hasAttr($name) ? $self->{attrs}{$name} : undef);
}

sub removeAttr {
	my ($self, $name) = @_;
	my $ret = undef;
	
	if ($self->hasAttr($name)) {
		$ret = $self->getAttr($name);
		delete $self->{attrs}{$name};
	}
	
	return $ret;
}

sub addAttr {
	my ($self, $name, $attr, $warn) = @_;
	$warn ||= 0;
	
	if ($self->hasAttr($name) and $warn) {
		croak sprintf("Class %s already has attribute %s", $self->getSymbolEntryName(), $name);
	}
	
	$self->{attrs}{$name} = $attr;
	
	return $attr;
}

sub createAttr {
	my ($self, $name, %args) = @_;
	carp "not implemented";
	
	my $ident_t = AST::Ident->new(
		{value => $name},
		0
	);
	
	say $ident_t;
	
	my $attr = Symbol::AttributeSymbol->new($ident_t);
	
}

1;
__END__

=head1 NAME

 Symbol::Base::AttibuteBase

=head1 SYNOPSYS

Provides common functions for handling attributes

=head1 DESCRIPTION



=head1 EXAMPLE

C<
package MySymbol;
use base qw/Symbol::SymbolEntry Symbol::Base::AttributeBase/;

sub new {
	my $c = shift;
	my $self = bless {} => $c;
	$self->hasAttr("default");
	
	return $self
}
>
=head1 LICENSE

Copyright (C) 2010 Richard Eames.
This module may be modified, used, copied, and redistributed at your own risk.
Publicly redistributed modified versions must use a different name.

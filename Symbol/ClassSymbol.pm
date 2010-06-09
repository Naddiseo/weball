package Symbol::ClassSymbol;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use base qw/Symbol::SymbolEntry/;

our $VERSION = 2010.06.08;

sub new {
	my ($c, $ast) = @_;
	
	my $self = $c->SUPER::new($ast->{name}, undef, $ast);
	
	$self->{attrs} = {};
	
	return $self;
}

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

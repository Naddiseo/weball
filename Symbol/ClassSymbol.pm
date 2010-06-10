package Symbol::ClassSymbol;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use base qw/Symbol::SymbolEntry/;

our $VERSION = 2010.06.09;

use Analysis::Function;

use Symbol::AttributeSymbol;
use Symbol::FunctionSymbol;
use Symbol::VariableSymbol;

sub new {
	my ($c, $ast) = @_;
	
	my $self = $c->SUPER::new($ast->{name}, undef, $ast);
	
	$self->{attrs}     = {};
	$self->{vars}      = {};
	$self->{functions} = {};
	
	$self->setType('Ptr', $self);
	
	return $self;
}

sub addVariable {
	my ($self, $varSym) = @_;
	
	my $name = $varSym->getSymbolEntryName();
	
	$self->{vars}{$name} = $varSym;
	$self->{scope}->define($name, $varSym);
	
	return $varSym;
}

sub addFunction {
	my ($self, $fnSym) = @_;
	
	my $name = $fnSym->getSymbolEntryName();
	
	$self->{functions}{$name} = $fnSym;
	$self->{scope}->define($name, $fnSym);
	
	$self->{scope}->startScope();
		$fnSym->setScope($self->getScope());
		Analysis::Function::analyse($fnSym);
	$self->{scope}->endScope();
	
	return $fnSym;
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

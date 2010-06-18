package Symbol::ClassSymbol;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

use base qw/Symbol::SymbolEntry Symbol::Base::AttributeBase/;

our $VERSION = 2010.06.12;

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
	
	$self->{varorder}  = [];
	
	$self->setType('Ptr', $self);
	
	return $self;
}

sub getVarCount {
	my ($self) = @_;
	
	return scalar(@{$self->{varorder}});
}

sub addVariable {
	my ($self, $varSym) = @_;
	
	my $name = $varSym->getSymbolEntryName();
	
	push @{$self->{varorder}}, $name;
	
	$self->{vars}{$name} = $varSym;
	$self->{scope}->define($name, $varSym);
	
	return $varSym;
}

sub addFunction {
	my ($self, $fnSym) = @_;
	
	my $name = $fnSym->getSymbolEntryName();
	
	#die(Dumper $fnSym);
	
	$self->{functions}{$name} = $fnSym;
	$self->{scope}->define($name, $fnSym);
	

	
	return $fnSym;
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

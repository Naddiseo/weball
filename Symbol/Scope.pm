package Symbol::Scope;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.07;

use Symbol::SymbolEntry;
use Symbol::ClassSymbol;
use Symbol::FunctionSymbol;
use Symbol::TemplateSymbol;
use Symbol::VariableSymbol;

sub new {
	my ($c) = @_;
	
	my $self = {
		#name      => '',
		parent    => undef, # Parent scope
		enclosing => undef, # In what scope was this scope defined?
		symbols   => {},    # Map of SymbolEntries
	};
	
	bless $self => $c;
}

sub getScopeName {
	my ($self) = @_;
	return $self->{name};
}

sub getParentScope {
	my ($self) = @_;
	return $self->{parent};
}

sub getEnclosingScope {
	my ($self) = @_;
	return $self->{enclosing};
}

sub startScope {
	my ($self) = @_;
	
	my $ret = Symbol::Scope->new();
	$ret->{parent} = $self;
	
	return $ret;
}

sub endScope {
	my ($self) = @_;
	return $self->getParentScope();
}

# Define a symbol in the current scope
sub define {
	my ($self, $name, $symEntry) = @_;
	
	if ($self->resolve($name)) {
		warn "Declaration of '$name' shadows a previous variable";
	}
	
	$symEntry->setScope($self);
	$self->{symbols}{$name} = $symEntry;
	
	return $symEntry;
}

# Return a SymbolEntry from this scope, or the parent if not here
sub resolve {
	my ($self, $name) = @_;
	
	my $ret = undef;
	
	if (exists $self->{symbols}{$name}) {
		$ret = $self->{symbols}{$name}; 
	}
	
	if (defined $self->{parent}) {
		$ret = $self->{parent}->resolve($name);
	}
	
	return $ret;
}

# returns VariableSymbol
sub resolveVariable {
	my ($self, $name) = @_;
	
	my $ret = $self->resolve($name);
	
	unless ($ret->isa('VariableSymbol')) {
		$ret = undef;
	}
	
	return $ret;
}

# returns ClassSymbol
sub resolveClass {
	my ($self, $name) = @_;
	
	my $ret = $self->resolve($name);
	
	unless ($ret->isa('ClassSymbol')) {
		$ret = undef;
	}
	
	return $ret;
}

# returns FunctionSymbol
sub resolveFunction {
	my ($self, $name, $argc) = @_;
	
	my $ret = $self->resolve($name);
	
	unless ($ret->isa('FunctionSymbol')) {
		$ret = undef;
	}
	elsif ($ret->{argc} != $argc) {
		$ret = undef;
	}
	
	return $ret;
}

# Returns SymbolEntry
sub remove {
	my ($self, $name) = @_;
	my $sym = $self->resolve($name);
	
	delete $self->{symbols}{$name} if $sym;
	
	return $sym;
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

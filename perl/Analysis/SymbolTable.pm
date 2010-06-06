package Analysis::SymbolTable;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

our $VERSION = 2010.06.03;

sub getInstance {
	state $instance = undef;
	
	unless (defined $instance) {
		$instance = Analysis::SymbolTable->new
	}
	
	return $instance;
}

=pod

level = 2
poped({a => 0, b => 1, c => 2, local => 3})
vars = [
	{a => 0, b => 1, c => 2},
	{a => 0, b => 1, c => 4, d => 5},
]
varNums = [
	Var(
		name  => 'a',
		value => 'foo',
		refs  => 1
	),
	Var(
		name  => 'b',
		value => 'bar',
		refs  => 1
	),
	Var(
		name => 'c'
		value => 'global c',
		refs  => 1,
	),
	Var(
		name  => 'local',
		value => 'var in old scope',
		refs  => 0,
	)
	Var(
		name  => 'c',
		value => 'local c',
		refs  => 1,
	),
	Var(
		name  => 'd',
		value => 'local d',
		refs  => 1
	)
]

=cut

sub new {
	my ($c) = @_;
	
	my $self = {
		level   => 0,
		# Stores a hash of numbers
		vars    => [], 
		varNums => [],
		name    => [],
	};
	
	bless $self => $c;
}

sub fqName {
	my ($self, $ident) = @_;
	
	die ref($ident) . ' not AST::Ident' if ref $ident ne 'AST::Ident';
}

sub startScope {
	my ($self, $name) = @_;
	
	my $vars = {};
	# Copy the current vars into the current scope.
	my $currentVars = $self->{vars}[$self->{level}];
	
	$name = '' unless defined $name;
	
	for my $varnum (keys %{$currentVars}) {
		$vars->{$varnum} = 1;
	}
	
	# Push the the new scope
	push @{$self->{vars}}, $vars;
	
	#Increase the level
	$self->{level}++;
	
	
	push @{$self->{name}}, $name;
	
	return undef;
}

sub endScope {
	my ($self) = @_;
	
	# Get the vars available in the scope
	my $oldvars = pop @{$self->{vars}};
	
	#say Dumper($oldvars);
	# Decrement the references
	for my $varnum (values %{$oldvars}) {
		unless (exists $self->{varNums}[$varnum]) {
			carp "Var num '$varnum' doesn't exist";
		}
		--$self->{varNums}[$varnum]{refs}
	}	
	
	# Save some memory
	undef $oldvars;
	
	# Decrease the level
	$self->{level}--;
	
	pop @{$self->{name}};
	
	return undef;
}

sub hasSym {
	my ($self, $name) = @_;
	
	my $vars = $self->{vars}[$self->{level}];
	
	return exists $vars->{$name};
}

sub getSym {
	my ($self, $name) = @_;
	
	return $self->{varNums}[$self->{vars}[$self->{level}]];
}

sub addSym {
	my ($self, $name, $type) = @_;
	
	carp "Symbol $name of type $type exists" if $self->hasSym($name);
	
	$self->{vars}[$self->{level}]{$name} = scalar (@{$self->{varNums}});
	
	$self->{varNums}[$self->{vars}[$self->{level}]{$name}] = {
		name  => $name,
		refs  => 1,
		value => $type
	};
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

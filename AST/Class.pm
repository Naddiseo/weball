package AST::Class;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

use AST::Attr;
use AST::Var;
use AST::Function;

our $VERSION = 2010.06.18;

sub new {
	my ($c, $ident, $attrs, $stmts) = @_;
	
	$attrs = [] unless defined $attrs;
	
	my $self = bless {
		name      => $ident,
		attrs     => {},
		vars      => {},
		functions => {},
		varorder  => [],
	} => $c;
	
	if (defined $stmts) {
		for my $stmt (@{$stmts}) {
			my $type = ref $stmt;
			
			if ($type eq 'AST::Var') {
				# a var declaration
				$self->addVar($stmt);
			}
			elsif ($type eq 'AST::Function') {
				$self->{functions}{$stmt->getLocalName()} = $stmt;
			}
			else {
				say "Class:Stmt: " . ref($stmt);
			}
		}
	}
	
	for my $attr (@{$attrs}) {
		$self->{attrs}{$attr->getName()} = $attr;
	}
	
	#die(Dumper(@_));
	
	return $self;
}

sub addVar {
	my ($self, $ast) = @_;
	
	my $name = $ast->getLocalName();
	
	push @{$self->{varorder}}, $name;
	$self->{vars}{$name} = $ast;
}

sub getLocalName {
	my ($self) = @_;
	return $self->{name}->getLocalName();
}

sub getVarCount {
	my ($self) = @_;
	return scalar @{$self->{varorder}};
}

sub getVars {
	my ($self) = @_;
	return %{$self->{vars}};
}

sub getAttrs {
	my ($self) = @_;
	return %{$self->{attrs}};
}

sub getFunctions {
	my ($self) = @_;
	return %{$self->{functions}};
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

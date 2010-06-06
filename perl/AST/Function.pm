package AST::Function;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.05;

sub new {
	my ($c, $ident, $args, $attrs, $stmts) = @_;
	
	$args  = [] unless defined $args;
	$attrs = [] unless defined $attrs;
	$stmts = [] unless defined $stmts;
	
	my $self = {
		name  => $ident,
		args  => $args,
		attr  => {},
		vars  => {},
		stmts => $stmts,
	};
	
	for my $attr (@{$attrs}) {
		$self->{attr}{$attr->getName()} = $attr;
	}

=pod

	# Vars should be done in the semantic phase.
	for my $stmt (@{$stmts}) {
		my $type = ref $stmt;
		given ($type) {
			when ('AST::Var') {
				$self->{vars}{$stmt->getName()} = $stmt;
			}
			default {
				push @{$self->{stmts}}, $stmt;
			}
		}
	}

=cut


	bless $self => $c;
}

sub getLocalName {
	my ($self) = @_;
	
	return $self->{name}->getLocalName();
}

sub getFqName {
	my ($self) = @_;
	
	return $self->{name}->getFqName();
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

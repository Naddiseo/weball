package AST::Class;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

use AST::Attr;
use AST::Var;
use AST::Function;

our $VERSION = 2010.06.05;

sub new {
	my ($c, $ident, $attrs, $stmts) = @_;
	
	$attrs = [] unless defined $attrs;
	
	my $self = {
		name => $ident,
		attr => {},
		vars => {},
		fn  => {},
	};
	
	if (defined $stmts) {
		for my $stmt (@{$stmts}) {
			my $type = ref $stmt;
			
			if ($type eq 'AST::Var') {
				# a var declaration
				$self->{vars}{$stmt->getLocalName()} = $stmt;
			}
			elsif ($type eq 'AST::Function') {
				$self->{fn}{$stmt->getLocalName()} = $stmt;
			}
			else {
				say "Class:Stmt: " . ref($stmt);
			}
		}
	}
	
	for my $attr (@{$attrs}) {
		$self->{attr}{$attr->getName()} = $attr;
	}
	
	#die(Dumper(@_));
	
	bless $self => $c;
}

sub getLocalName {
	my ($self) = @_;
	return $self->{name}->getLocalName();
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

package Eval::Eval;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

our $VERSION = 2010.06.08;

sub new {
	my ($c, $ctx) = @_;
	
	my $self = {
		ctx => 
	};
	
	bless $self => $c;
}

sub b2i {
	my ($node) = @_;
	
	#die Dumper($node);
	
	if ($$node->{type} eq 'bool') {
		$$node->{value} =~ s/true/\(1\)/g;
		$$node->{value} =~ s/false/\(0\)/g;
	}
}

sub i2b {
	my ($node) = @_;
	
	#die Dumper($node);
	
	if (${$node}->{type} eq 'bool') {
		${$node}->{value} =~ s/1/true/g;
		${$node}->{value} =~ s/0/false/g;
	}
}

sub evalNode {
	my ($self, $node) = @_;
	
	my $ret = undef;
	
	my $sym = undef;
	
	given (ref $node) {
		when ('AST::FNCall') {
			my $fn = $sym->getSym($node->getName());
			
			croak "couldn't find sym" unless defined $fn;
		
			unless ($fn->{attrs}{const}) {
				croak 'Cannot eval non const function "' . $node->getName() . '"';
			}
		}
		when (/AST::Primitive/) {
			$ret = $node;
		}
		when (/AST::Math/) {
			my $nodetype = $node->{type};
			my $lhs      = $self->evalNode($node->{lhs});
			my $rhs      = $self->evalNode($node->{rhs});
			
			if ($lhs->{type} !~ /$nodetype/) {
				carp "LHS of MathOp::'$node->{op}' is '$lhs->{type}' and not '$nodetype'";
			}
			if ($rhs->{type} !~ /$nodetype/) {
				carp "RHS of MathOp::'$node->{op}' is '$lhs->{type}' and not '$nodetype'";
			}
			
			b2i(\$lhs);
			b2i(\$rhs);
			
			my $evalStr = "($lhs->{value}) $node->{op} ($rhs->{value})";
			#say "evaling: $evalStr";
			
			$ret = {
				value => eval($evalStr),
				type => $nodetype,
			};
			
			i2b(\$ret);
		}
		default {
			croak "Unknown node '$_' to eval";
		}
	}
	
	return $ret;
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

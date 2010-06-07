package Analysis::Var;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.06;

use Eval::Eval;

sub new {
	my ($c, $ast) = @_;
	
	my $self = {
		ast        => $ast,
		fqname     => $ast->getFqName(),
		localname  => $ast->getLocalName(),
		type       => $ast->{type},
		attrs      => {},
	};
	
	bless $self => $c;
}

sub badTypeError {
	my ($self, $default) = @_;
	
	unless (exists $default->{token}) {
		# TODO: grab this from a subtree
		$default->{token} = {
			line => -1,
			char => -1,
		};
	}
	
	croak "[$default->{token}{line}:$default->{token}{char}]Trying to assign a '$default->{type}' to a '$self->{type}' variable";
}

sub analyse {
	my ($self) = @_;
	
	my $ast = $self->{ast};
	delete $self->{ast};
	
	my $eval = Eval::Eval->new;
	
	if (my $default = $ast->{attr}{default}) {
	
		if ($default->{type} eq 'function_call') {
			my $ret = $eval->evalNode($default);
		}
	
		# must be the same type as the variable
		given ($self->{type}) {
			when (/^int|uint/) {
				$self->badTypeError($default) if ($default->{type} ne 'int');
				
				# TODO: check attrs of var for limitations
			}
			when (/^string/) {
				$self->badTypeError($default) if ($default->{type} ne 'string');
			}
			when (/^bool/) {
				$self->badTypeError($default) if ($default->{type} ne 'bool');
			}
			when (/^double/) {
				$self->badTypeError($default) if ($default->{type} !~ /^int|double/);
			}
			default {
				$self->badTypeError($default);
			}
		}
		
		# else it's all good
		if (ref $default eq 'AST::Primitive') {
			$self->{attrs}{default} = $default->{value};
		}
		else {
			# Try to eval it
			
			$self->{attrs}{default} = $eval->evalNode($default);
		}
		delete $ast->{attr}{default};
		delete $self->{attrs}{default} unless defined $self->{attrs}{default};
	}
	
	while (my ($attrname, $attr) = each %{$ast->{attr}}) {
		$self->{attrs}{$attrname} = $attr;
	}
	
	return $self;
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

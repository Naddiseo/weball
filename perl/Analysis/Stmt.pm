package Analysis::Stmt;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.06;

use Sem::Temp;
use Sem::MathOp;

sub new {
	carp "Analysis::Stmt does not implement new()";
}

sub analyse {
	my ($stmt, $type) = @_;
	
	my $ret = {
		type => 'undef',
		val  => undef,
	};
	
	given (ref $stmt) {
		when ('AST::Ident') {
			# Look up fqname
		}
		when ('AST::Return') {
			my $tmp = Sem::Temp->new();
			$ret = $tmp->assign(analyse($stmt->{expr}));
		}
		when (/AST::Math/) {
			my $lhs = Sem::Temp->new();
			my $rhs = Sem::Temp->new();
			
			$lhs->assign(analyse($stmt->{lhs}, 'number'));
			$rhs->assign(analyse($stmt->{rhs}, 'number'));
			
			$ret = Sem::MathOp->new($stmt->{op}, $lhs, $rhs);
		}
		default {
			say "Analysis::Stmt::analyse: '$_'";
		}
	}
	
	if (defined $type and $ret->{type} ne $type) {
		carp "Analysis::Stmt::analyse(): A type of '$type' was not returned. ($ret->{type})";
	}
	
	return $ret->{val};
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

package Analysis::Function;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.08;

use Analysis::Stmt;

sub new {
	my ($c, $ast) = @_;
	
	my $self = {
		name   => $ast->getLocalName(),
		fqname => $ast->getFqName(),
		ast    => $ast,
		attrs  => $ast->{attrs},
		stmts  => [],
	};
	
	bless $self => $c;
}

sub getLocalName {
	my ($self) = @_;
	return $self->{name}
}


sub analyse {
	my ($self) = @_;
	my $ast = $self->{ast};
	delete $self->{ast};
	
	my $sym = undef;
	for my $arg (@{$ast->{args}}) {
		$arg->{name}->addPart(split /\./, $self->{fqname});
		$sym->addSym($arg->getFqName(), $arg);
	}
	
	for my $stmt (@{$ast->{stmts}}) {
		say sprintf("%s::analyse(%s)", __PACKAGE__, ref $stmt);
		push @{$self->{stmts}}, Analysis::Stmt::analyse($stmt);
		
	}

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

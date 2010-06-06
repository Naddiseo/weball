package Analysis::Class;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

our $VERSION = 2010.06.06;

use Analysis::Var;
use Analysis::Function;
use Analysis::SymbolTable;

sub new {
	my ($c, $ast) = @_;
	
	my $self = {
		name => $ast->{name}->getLocalName(), 
		ast  => $ast,
		fn   => {},
		attr => {},
		vars => {}
	};
	
	bless $self => $c;
}

sub getLocalName {
	my ($self) = @_;
	return $self->{name};
}

sub analyse {
	my ($self) = @_;
	
	my $ast = $self->{ast};
	delete $self->{ast};
	
	my $sym = Analysis::SymbolTable::getInstance();
	
	$sym->addSym($self->{name}, $self);
	
	while (my ($varname, $var) = each %{$ast->{vars}}) {
		$var->{name}->addPart($self->getLocalName());
		
		my $lvar = Analysis::Var->new($var);
		$lvar->analyse();
		
		$self->{vars}{$var->getLocalName()} = $lvar;
		
		$sym->addSym($var->getFqName(), $lvar);
	}
	
	while (my($fnname, $fn) = each %{$ast->{fn}}) {
		$fn->{name}->addPart($self->getLocalName());
		
		my $lfn = Analysis::Function->new($fn);
		
		$sym->startScope();
			$lfn->analyse();
		$sym->endScope();
		
		$sym->addSym($fn->getFqName(), $lfn);
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

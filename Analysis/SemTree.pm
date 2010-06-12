package Analysis::SemTree;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.08;

use Symbol::Scope;

sub new {
	my ($c, $ctx) = @_;
	
	my $self = {
		scope     => Symbol::Scope->new(),
		templates => {},
		classes   => {},
		functions => {},
	};
	
	bless $self => $c;
}

sub startScope {
	my ($self) = @_;
	$self->{scope} = $self->{scope}->startScope();
}

sub endScope {
	my ($self) = @_;
	$self->{scope} = $self->{scope}->endScope();
}

sub getScope {
	my ($self) = @_;
	return $self->{scope};
}

sub defineClass {
	my ($self, $classSym) = @_;
	
	my $name = $classSym->getSymbolEntryName();
	
	$self->{classes}{$name} = $classSym;
	
	my $sym = $self->define($name, $classSym);
				
	$self->startScope();
		$sym->setScope($self->getScope());
		Analysis::Class::analyse($sym);
	$self->endScope();
}

sub defineFunction {
	my ($self, $fnSym) = @_;
	
	my $name = $fnSym->getSymbolEntryName();
	
	$self->{functions}{$name} = $fnSym;
	
	my $sym = $self->define($name, $fnSym);
	
	$self->startScope();
		$sym->setScope($self->getScope());
		Analysis::Function::analyse($sym);
	$self->endScope();
}

sub define {
	my ($self, @args) = @_;
	$self->{scope}->define(@args);
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

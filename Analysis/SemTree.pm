package Analysis::SemTree;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.02;

use Sem::Context;

sub new {
	my ($c, $ctx) = @_;
	
	my $self = {
		ctx       => (ref $ctx ? $ctx : Sem::Context->new),
		templates => {},
		classes   => {},
		functions => {}
	};
	
	bless $self => $c;
}

sub addTemplate {
	my ($self, $tpl) = @_;
	
	my $name = $tpl->getLocalName();
	
	if ($self->{templates}{$name}) {
		carp "Template '$name' already exists";
	}
	
	$self->{ctx}->addTemplate($name);
	
	$self->{templates}{$name} = $tpl;
}

sub addClass {
	my ($self, $class) = @_;
	
	my $name = $class->getLocalName();
	
	if ($self->{classes}{$name}) {
		carp "Class '$name' already exists";
	}
	
	$self->{classes}{$name} = $class;
}

sub addFunction {
	my ($self, $fn) = @_;
	
	my $name = $fn->getLocalName();
	
	if ($self->{functions}{$name}) {
		carp "Function '$name' already exists";
	}
	
	$self->{functions}{$name} = $fn;
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

package AST::Class;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use AST::Class::Attr;
use AST::Class::Var;
use AST::Class::DBFunction;

our $VERSION = 2010.05.01;

sub new {
	my ($c, $name) = @_;
	
	my $self = {
		name => $name,
		attr => {},
		vars => {},
		dbf  => {},
	};
	
	bless $self => $c;
}

sub addAttr {
	my ($self, $a) = @_;

	if ($self->{attr}{$a->{name}}) {
		carp "Class $self->{name} already has attribute $a->{name}";
	}

	$self->{attr}{$a->{name}} = $a;
}

sub addVar {
	my ($self, $var) = @_;

	$self->{vars}{$var->{name}} = $var;
}

sub addDBF {
	my ($self, $var) = @_;

	$self->{dbf}{$var->{name}} = $var;
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

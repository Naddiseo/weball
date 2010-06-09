package Symbol::SymbolEntry;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.08;

use Symbol::TypeFactory;

sub new {
	my ($c, $ident_t, $scope, $ast) = @_;
	
	my $self = {
		name  => $ident_t->getLocalName(),
		type  => Symbol::TypeFactory::createType('Unresolved'),
		scope => ($scope || undef),
		ast   => ($ast || undef),
		line  => $ident_t->{ident}->line,
		char  => $ident_t->{ident}->char,
	};
	
	bless $self => $c;
}

sub getSymbolEntryName {
	my ($self) = @_;
	return $self->{name};
}

sub setType {
	my ($self, $typename) = @_;
	$self->{type} = Symbol::TypeFactory::createType($typename);
	return $self->getType();
}

sub getType {
	my ($self) = @_;
	return $self->{type};
}

sub getScope {
	my ($self) = @_;
	return $self->{scope};
}

sub setScope {
	my ($self, $scope) = @_;
	$self->{scope} = $scope;
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

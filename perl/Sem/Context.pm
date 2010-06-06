package Sem::Context;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.02;

use Analysis::SymbolTable;

sub new {
	my ($c, $sym) = @_;
	
	my $self = {
		evalnow => 0,
		sym     => (ref $sym ? $sym : Analysis::SymbolTable::getInstance())
	};
	
	bless $self => $c;
}

sub resolve {
	my ($self, $fqstr) = @_;
}

sub addTemplate {
	my ($self, $name) = @_;
	$self->{sym}->addSym($name, 'TEMPLATE');
}

sub addClass {
	my ($self, $name) = @_;
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

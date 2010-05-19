package AST::Block;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.16;

sub new {
	my ($c) = @_;
	
	my $self = {
		stmts => []
	};
	
	bless $self => $c;
}

sub addStmt {
	my ($self, $stmt) = @_;
	
	push @{$self->{stmts}}, $stmt;
	$self
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

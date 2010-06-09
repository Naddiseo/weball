package Symbol::SymbolTable;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.07;

use Symbol::SymbolEntry;

sub getInstance {
	state $i = undef;
	
	unless (defined $i) {
		$i = Symbol::SymbolTable->new(),
	}
	
	return $i;
}

sub new {
	my ($c) = @_;
	
	my $self = {
		count => 0,
		syms  => {},
		
		symbyN => [],
	};
	
	bless $self => $c;
}

sub addSymbol {
	my ($self, $localname) = @_;
	
	unless (exists $self->{syms}{$localname}) {
		my $id = ++$self->{count};
		$self->{syms}{$localname} = $id;
		
		my $sym = Symbol::SymbolEntry->new($id);
		$sym->{localname} = $localname;
		
		push @{$self->{symbyN}}, $sym;
	}
	
	return $self->{syms}{$localname};
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

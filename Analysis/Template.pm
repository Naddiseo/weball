package Analysis::Template;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.28;

use AST::Template;
use AST::Attr;

use Analysis::Attr;
use Analysis::SymbolTable;

sub new {
	my ($c, $tpl) = @_;
	
	my $self = {
		name  => $tpl->getName(),
		stmts => [],
		attrs => [],
		syms  => Analysis::SymbolTable::getInstance(),
	};
	
	if ($tpl->hasAttr('html')) {
		require Analysis::Template::HTML;
		my $html = Analysis::Template::HTML->new($self->{syms});
		my $stmts = $html->analyse($tpl->{stmts});
		push @{$self->{stmts}}, @$stmts
	}
	
	bless $self => $c;
}

sub getName {
	my ($self) = @_;
	return $self->{name};
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

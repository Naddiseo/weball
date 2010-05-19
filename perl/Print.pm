package Print;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.16;

sub new {
	my ($c) = @_;
	
	my $self = {
	
	};
	
	bless $self => $c;
}

sub printTree {
	my ($tree, $tab) = @_;
	
	if (!ref $tree) {
		die "Not tree ref"
	}
	
	$tab = '' unless defined $tab;
	
	given (ref $tree) {
		when ('ARRAY') {
			for my $branch (@{$tree}) {
				printTree($branch, "$tab ");
			}
		}
		when ('AST::Stmt::If') {
			
		}
		when ('AST::Class::DBFunction') {
			say "$tab-Args: ";
			for my $arg (@{$tree->{args}}) {
				printTree($arg, "$tab ");
			}
			while (my($k, $v) = each %{$tree->{attr}}) {
				say "$tab-Attr($k) :";
				printTree($v, "$tab ");
			}
			while (my($k, $v) = each %{$tree->{vars}}) {
				say "$tab-Var($k) :";
				printTree($v, "$tab ");
			}
			for my $stmt (@{$tree->{stmts}}) {
				printTree($stmt, "$tab ");
			}
		}
		when ('AST::Class') {
			say "$tab-Class($tree->{name}):";
			$tab .= ' ';
			
			while (my($k, $v) = each %{$tree->{attr}}) {
				say "$tab-Attr($k) :";
				printTree($v, "$tab ");
			}
			
			while (my($k, $v) = each %{$tree->{vars}}) {
				say "$tab-Var($k) :";
				printTree($v, "$tab ");
			}
			while (my($k, $v) = each %{$tree->{dbf}}) {
				say "$tab-DBF($k) :";
				printTree($v, "$tab ");
			}
			
		}
		when (/./) {
			say $tab . ref($tree);
		}
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

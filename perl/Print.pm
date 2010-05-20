package Print;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.19;

use Data::Dumper;

sub new {
	my ($c) = @_;
	
	my $self = {
	
	};
	
	bless $self => $c;
}

sub printTree {
	my ($tree, $tab) = @_;
	
	if (!ref $tree) {
		say "Called from  line " . (caller())[2];
		die "tree isn't defined" unless defined $tree;
		die "$tree Not tree ref"
	}
	
	$tab = '' unless defined $tab;
	
	given (ref $tree) {
		when ('ARRAY') {
			for my $branch (@{$tree}) {
				printTree($branch, "$tab ");
			}
		}
		
		when ('AST::Block') {
			say "$tab\{";
				printTree($tree->{stmts}, $tab);
			say "$tab}";
		}
		
		when ('AST::Primitive') {
			say "${tab}Const($tree->{type}:$tree->{value})";
		}
		
		when ('AST::Stmt::ElseIf') {
			say $tab . "ELSE IF(";
				printTree($tree->{cond}, "$tab ");
			say $tab . ") ";
				printTree($tree->{block}, $tab);
				#for my $stmt (@{$tree->{stmts}}) {
				#	printTree($stmt, $tab);
				#}
		}
		
		when ('AST::Stmt::If') {
			say $tab . "IF("; 
				printTree($tree->{cond}, "$tab ");
			say "$tab) THEN";
				printTree($tree->{block}, $tab);
			for my $ei (@{$tree->{elseifs}}) {
				next unless defined $ei;
				
				printTree($ei, $tab);
			}
			say "${tab}ELSE";
			printTree($tree->{'else'}, $tab) if $tree->{'else'};
			say $tab . "END IF;";
		}
		
		when ('AST::Class::DBFunction') {
			say "$tab Args:  None" unless scalar @{$tree->{args}};
			
			for my $arg (@{$tree->{args}}) {
				print "$tab Arg: ";
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

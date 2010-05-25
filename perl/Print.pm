package Print;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.22;

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
				printTree($branch, "$tab ") if defined $branch;
			}
		}
		
		when ('AST::Math::Incr') {
			printTree($tree->{expr});
		}
		
		when ('AST::Math::Decr') {
			printTree($tree->{expr});
		}
		
		when (/^AST::Math::/) {
			say "${tab}OP($tree->{op}) : ";
			say "${tab}(";
				if (defined $tree->{expr}) {
					# It's a unary op
					printTree($tree->{expr}, "$tab  ");
				}
				else {
					printTree($tree->{lhs}, "$tab  ");
					printTree($tree->{rhs}, "$tab  ");
				}
			say "${tab})";
		}

		when ('AST::Assign') {
			say "${tab}ASSIGN : ";
			say "${tab}(";
				printTree($tree->{lhs}, "$tab  ");
				printTree($tree->{rhs}, "$tab  ");
			say "${tab})";
		}
		
		when ('AST::Return') {
			say "${tab} RETURN ";
			printTree($tree->{expr}, "$tab  ");
		}
		
		when ('AST::Var') {
			say "${tab}Var($tree->{type}) " . $tree->getName();
			while (my($k, $v) = each %{$tree->{attr}}) {
				say "$tab -Attr($k) :";
				printTree($v, "$tab   ");
			}
		}
		
		when ('AST::Ident') {
			say "${tab}Ident(" . $tree->fqName() . ")";
		}
		
		when ('AST::Attr') {
			if (scalar @{$tree->{args}}) {
			
				say "$tab\[";
			
				for my $arg (@{$tree->{args}}) {
					printTree($arg, "$tab ");
				}
			
				say "$tab\]";
			}
		}
		
		when ('AST::Block') {
			say "$tab\{";
				printTree($tree->{stmts}, $tab);
			say "$tab}";
		}
		
		when ('AST::Expr') {
			printTree($tree->{block}, $tab);
		}
		
		when ('AST::Primitive') {
			say "${tab}Const($tree->{type}:$tree->{value})";
		}
		
		when ('AST::Stmt::ElseIf') {
			say $tab . "ELSE IF(";
				printTree($tree->{cond}, "$tab ");
			say $tab . ") ";
				printTree($tree->{block}, $tab);
		}
		
		when ('AST::Stmt::If') {
			say $tab . "IF("; 
				printTree($tree->{cond}, "$tab ");
			say "$tab) THEN {";
				printTree($tree->{block}, $tab);
			say "$tab}";
			for my $ei (@{$tree->{elseifs}}) {
				next unless defined $ei;
				
				printTree($ei, $tab);
			}
			say "${tab}ELSE";
			printTree($tree->{'else'}, $tab) if defined $tree->{'else'};
			say $tab . "END IF;";
		}
		
		when ('AST::Stmt::While') {
			say $tab, 'WHILE(';
				printTree($tree->{cond}, "$tab ");
			say $tab, ') DO {';
				printTree($tree->{block}, $tab);
			say $tab, '} DONE;';
		}
		
		when ('AST::Stmt::For') {
			printTree($tree->{var}, $tab);
			say $tab, 'WHILE(';
				printTree($tree->{cond}, "$tab ");
			say $tab, ') DO {';
				printTree($tree->{block}, "$tab ");
				printTree($tree->{inc}, "$tab ");
			say $tab, '} DONE;';
		}
		
		when ('AST::Function') {
			say "$tab-FN(" . $tree->getName() .") :";
			say "${tab}(";
			say "$tab Args:  None" unless scalar @{$tree->{args}};
			
			for my $arg (@{$tree->{args}}) {
				say "$tab Arg: ";
				printTree($arg, "$tab  ");
			}
			say "${tab})";
			
			
			while (my($k, $v) = each %{$tree->{attr}}) {
				say "$tab-Attr($k) :";
				printTree($v, "$tab ");
			}
			while (my($k, $v) = each %{$tree->{vars}}) {
				say "$tab-Var($k) :";
				printTree($v, "$tab ");
			}
			say "${tab}{";
			for my $stmt (@{$tree->{stmts}}) {
				printTree($stmt, "$tab "); say ';';
			}
			say "${tab}}";
		}
		
		when ('AST::Class') {
			say "$tab-Class($tree->{name}):";
			$tab .= ' ';
			#die(Dumper($tree));
			while (my($k, $v) = each %{$tree->{attr}}) {
				say "$tab-Attr($k) :";
				printTree($v, "$tab ");
			}
			
			while (my($k, $v) = each %{$tree->{vars}}) {
				say "$tab-Var($k) :";
				printTree($v, "$tab ");
			}
			while (my($k, $v) = each %{$tree->{fn}}) {
				printTree($v, "$tab ");
			}
			
		}
		
		when ('AST::FNCall') {
			#die Dumper($tree);
			say $tab, 'CALL(', $tree->getName(), ')';
			say "${tab}(";
			say "$tab Args:  None" unless scalar @{$tree->{args}};
			
			for my $arg (@{$tree->{args}}) {
				say "$tab Arg: ";
				printTree($arg, "$tab  ");
			}
			say "${tab})";
		}
		
		when ('AST::GetMember') {
			say $tab, 'GETMEMBER:';
			printTree($tree->{lhs}, $tab);
			printTree($tree->{rhs}, $tab);
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

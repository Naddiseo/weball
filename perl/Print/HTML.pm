package Print::HTML;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

our $VERSION = 2010.05.25;

use AST::Template;
use AST::Template::Node;
use AST::Primitive;

sub print {
	my ($c, $template) = @_;
	
	say "Template " . $template->{name};
	$c->printStmts($template->{stmts});
	
}

sub printStmts {
	my ($c, $stmts) = @_;
	for my $stmt (@$stmts) {
	
		given (ref $stmt) {
			when ('AST::Template::Node') {
				$c->printNode($stmt);
			}
			when ('AST::Primitive') {
				$c->printPrimitive($stmt);
			}
		}
		#say ref $stmt;
	}
}

sub printNode {
	my ($c, $node) = @_;
	my $name = $node->{name};
	
	say "<$name" . $c->flattenAttrs($node->{attr}) . '>';
	
	$c->printStmts($node->{stmts});
	
	say "</$name>";
}

sub flattenAttrs {
	my ($c, $attrs) = @_;
	
	my $ret = '';
	
	while (my ($name, $attr) = each %{$attrs}) {
		$ret .= ' ' . $name;
		
		for my $arg (@{$attr->{args}}) {
			if (ref $arg ne 'AST::Primitive') {
				carp "Print::HTML does not yet support complex arguments for attributes"
			}
			
			$ret .= '="' . $arg->{value} . '"';
		}
		
	}
	
	
	return $ret;
}

sub printPrimitive {
	my ($c, $node) = @_;
	given ($node->{type}) {
		when ('number') {
			say $node->value;
		}
		when ('string') {
			say $node->value;
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

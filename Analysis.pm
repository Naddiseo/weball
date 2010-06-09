package Analysis;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.07;

use Analysis::SemTree;

use Symbol::Scope;
use Symbol::SymbolTable;
use Symbol::ClassSymbol;
use Symbol::FunctionSymbol;
use Symbol::TemplateSymbol;
use Symbol::VariableSymbol;

use Analysis::Template;
use Analysis::Class;
use Analysis::Function;

sub new {
	my ($c, $ast) = @_;
	
	my $self = {
		ast => $ast
	};
	

	bless $self => $c;
}

sub analyse {
	my ($self) = @_;
	my $ret    = Analysis::SemTree->new();
	my $fqname = '';
	
	# Instanciate the symboltable
	#my $sym = Analysis::SymbolTable::getInstance();
	
	for my $stmt (@{$self->{ast}}) {
	
		# TODO: circular references
		
		given(ref $stmt) {
			when ('AST::Class') {
				# Put the AST directly into the symbol
				my $symEntry = Symbol::ClassSymbol->new($stmt);
				my $sym = $ret->define($symEntry->getSymbolEntryName(), $symEntry);
				
				$ret->startScope();
					$sym->setScope($ret->getScope());
					Analysis::Class::analyse($sym);
				$ret->endScope();
				
			}
			when ('AST::Function') {
				#my $semFn = Analysis::Function->new($stmt);
				#$ret->addFunction($semFn);

				#$sym->startScope();
				#	$semFn->analyse();
				#$sym->endScope();
			}
			when ('AST::Template') {
				#my $semTPL = Analysis::Template->new($stmt);
				#$ret->addTemplate($semTPL);
				
				#$sym->startScope();
				#	$semTPL->analyse();
				#$sym->endScope();
			}
			default {
				carp "Analysis::analyse unknown ref '$_'";
			}
		}
	}

	return $ret;
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

package Analysis::Template::HTML;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.05.28;

use Analysis::SymbolTable;


use Data::Dumper;

my %tags = map { $_ => 1 } qw(
a abbr address area article aside audio b base bdo blockquote body br button
canvas caption cite code col colgroup command datalist dd del details dfn
div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6
head header hgroup hr html i iframe img input ins keygen kbd label legend
li link map mark menu meta meter nav noscript object ol optgroup option output
p param pre progress q rp rt ruby samp script section select small source span 
strong style sub summary sup table tbody td textarea tfoot th thead time title 
tr ul var video
);

sub new {
	my ($c, $syms) = @_;
	
	my $self = {
		syms => $syms
	};
	
	bless $self => $c;
}

sub analyse {
	my ($self, $stmts) = @_;
	#die Dumper($stmts);
	
	my @ret = ();
	
	for my $stmt (@{$stmts}) {
		given (ref $stmt) {
			when ('AST::Template::Node') {
				push @ret, $self->processNode($stmt);
			}
			when ('AST::FNCall') {
				my $fnName = $stmt->getName();
				if (my $sym = $self->{syms}->hasSym($fnName)) {
					push @ret, $self->{syms}->getSym($fnName)->($stmt->{stmts});
				}
				else {
					push @ret, [
						'<? %s(%s) ?>',
						$fnName,
						$self->analyse($stmt->{stmts})
					]
					#eval "$fnName(\$stmt);";
					#if ($@) {
					#	carp "Function $fnName doesn't exist in symbol table\n $@";
					#}
				}
			}
		}
	}
	
	return [@ret];
}

sub processNode {
	my ($self, $stmt) = @_;
	
	my $ret = [];
	
	if (exists $tags{$stmt->getName()}) {
		my $tagname = $stmt->getName();
		# if it's an HTML tag, then process now.
		$ret = [[ 
			'<%s%s>',
			$stmt->getName(),
			$self->processAttrList($stmt->{attrs}),
			$self->analyse($stmt->{stmts}),
			'</%s>', 
		]];
	}
	else {
		say Dumper($stmt);
		die "HTML element doesn't exist " . $stmt->getName() . ' ' . ref $stmt;
	}
	
	for my $s (@{$stmt->{stmts}}) {
		push @$ret, $self->processNode($s);
	}
	
	return $ret;
}

sub processAttrList {
	my ($self, $attrs) = @_;
	
	my $ret = [];
	
	while (my ($name, $attr) = each %{$attrs}) {
		push @$ret, $attr
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

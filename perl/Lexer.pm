package Lexer;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.04.25;

our $PUNCT_TREE = {
	'!' => {
		'='       => 1,
		'default' => 1
	},
	'%' => {
		'='       => 1,
		'default' => 1,
	},
	'^' => {
		'='       => 1,
		'default' => 1,
	},
	'&' => {
		'&'       => 1,
		'='       => 1,
		'default' => 1,
	}, 
	'*' => {
		'='       => 1,
		'default' => 1,
	},
	'-' => {
		'-'       => 1,
		'='       => 1,
		'default' => 1,
	},
	'+' => {
		'+'       => 1,
		'='       => 1,
		'default' => 1,
	},
	'=' => {
		'='       => 1,
		'default' => 1,
	},
	'|' => {
		'|'       => 1,
		'='       => 1,
		'default' => 1,
	},
	'/' => {
		'='       => 1,
		'default' => 1,
	},
	'<' => {
		'<'       => {
			'='       => 1,
			'default' => 1
		},
		'='       => 1,
		'default' => 1,
	},
	'>' => {
		'>'       => {
			'='       => 1,
			'default' => 1
		},
		'='       => 1,
		'default' => 1,
	},
	'~'  => 1,
	'('  => 1,
	')'  => 1,
	'['  => 1,
	']'  => 1,
	'{'  => 1,
	'}'  => 1,
	','  => 1,
	'.'  => 1,
	'?'  => 1,
	';'  => 1,
	':'  => 1,
	'\'' => 1,
	'"'  => 1,
};

sub new {
	my ($c, $str) = @_;
	
	my $self = {
		str => $str,
		tokens => [],
	};
	
	bless $self => $c;
}

sub tokenize {
	my ($self) = @_;
	my $tok     = '';
	my @chars   = split //, $self->{str};
	my @tokens  = ();

	while (my $c = shift @chars) {
		last unless defined $c;
		given ($c) {
			when (/\s/) {
				# No nothing
			}
			when (/[a-z]/i) {
				while (defined $c and $c =~ /[[:alnum:]]/) {
					$tok .= $c;
					$c = shift @chars;
				}

				# TODO: check if token
				
				push @tokens, $tok;
				#say "token : $tok";
				$tok = '';

				redo;
			}
			when (/[0-9]/i) {
				# TODO: allow hex
				while (defined $c and $c =~ /[[:digit:]]/) {
					$tok .= $c;
					$c = shift @chars;
				}
				push @tokens, $tok;
				$tok = '';
				redo;
			}
			when (/[~!%^&*\(\)\-\+=\[\]\{\}\|\'\"\;:\?\/<>,\.]/) {
				my $p = $self->parsePunctTree($_, \@chars);
				#say "Got punct $p";
				push @tokens, $p;
			}
			default {
				croak "Unknown char $c";
			}
		}
		#say "c: '$c'";
	}

	push @{$self->{tokens}}, @tokens;
	return @tokens
}

sub parsePunctTree {
	my ($self, $char, $char_ref, $tree) = @_;

	my $val = '';

	my $ret = $char;

	$tree = $Lexer::PUNCT_TREE unless defined $tree;

	return $val unless defined $char;

	#use Data::Dumper;
	#print "testing if '$char' is in tree..";
	
	if (exists $tree->{$char}) {
		#say "yes";
		$val = $tree->{$char};
	}
	else {
		#say "no, putting '$char' back";
		unshift @{$char_ref}, $char;

		return '';
	}

	if (ref $val eq 'HASH') {
		my $c = shift @{$char_ref};
		#say "testing '$c'";
		$ret .= $self->parsePunctTree(
			$c,
			$char_ref,
			$val
		);
	}
	elsif ($val == 1) {
		# accept
		#say "accept char '$char'";
		return $ret;
	}
	else {
		# operator doesn't exist
		say "opertator $char doesn't exist"
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

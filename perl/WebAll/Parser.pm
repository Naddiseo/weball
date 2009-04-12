package WebAll::Parser;

use strict;
use warnings;

use 5.010;

use Data::Dumper;

our $VERSION = '2.0.0';

sub new {
	my ($c, $lexer) = @_;
	$c = ref $c || $c;
	
	my $self = {
		lex => $lexer,
		look => undef,
		peek => undef,
		t => undef,
		v => undef,
		types => {
			'INT' => {},
			'UINT' => {},
			'FLOAT' => {},
			'STRING' => {},
			'BOOL' => {},
		}
	};
	
	bless $self => $c;	
}

sub next {
	my $self = shift;
	
	$self->{look} = $self->{peek};
	$self->{peek} = $self->{lex}->yylex;
	$self->{t}    = $self->{look}[0];
	$self->{v}    = $self->{look}[1];
	say "=$self->{t} ($self->{v})" if $self->{t};
}

sub error {
	my ($self, $msg) = @_;
	
	my ($line, $char) = @{$self->{look}}[2, 3];
	
	die "Parse error [$line : $char]: $msg\n"
	
}

sub expect {
	my ($self, $t) = @_;
	
	$self->error("Expected $t, got $self->{look}[0]")
}

sub match {
	my ($self, $t, %args) = @_;
	
	my $check = 1;
	
	if ($args{v}) {
		$check = 0 unless $self->{v} eq $args{v}
	}
	
	unless ($self->{t} eq $t and $check) {
		$self->expect($t)
	}
	
	$self->next unless $args{hold};
}

sub init {
	my $self = shift;

	$self->next;
	$self->next;
	
	$self->program;	
}

sub program {
	my $self = shift;
	
	my @ast = ();
	
	TOKEN: while (defined $self->{t} and $self->{t} ne 'EOF') {
		given ($self->{t}) {
			when ('CONFIG') {
				$self->match('CONFIG');
				$self->match('EOL');
				push @ast, $self->getConfigLines;
			}
			
			when ('CLASS') {
				my $name = $self->{v};
				$self->match('CLASS');
				$self->match('EOL');
				push @ast, ['CLASS', $name, $self->getClassLines];				
			}
			
			when ('TYPEDEF') {
				my $name = $self->{v};
				$self->match('TYPEDEF');
				my ($type, @attr) = $self->getType;
				push @attr, @{$self->getAttrs};
				push @ast, ['TYPEDEF', $type, $name, [@attr]];
			}
			
			when ('BOL') {
				print Dumper(\@ast);
				$self->error('Badly indented');
			}
		}
		#$self->next;
	}
	
	return [@ast];
}

sub getConfigLines {
	my $self = shift;
	
	my @ast = ();
	
	while ($self->{t} eq 'BOL' and $self->{v} == 1) {
		$self->match('BOL', v => 1);
		my $key = '';
		my $value = '';
		if ($self->{t} eq 'IDENT') {
			$key = $self->getIdent;
			$self->match('LPAREN');
			$value = $self->numOrString;
			$self->match('RPAREN');
			$self->match('EOL');
			push @ast, [$key, $value];
		}
		else {
			$self->expect('IDENT');
		}		
	}
	
	return ['CONFIG', [@ast]]
}

sub getClassLines {
	my $self = shift;
	
	my @ast = ();
	
	while ($self->{t} eq 'BOL' and $self->{v} == 1) {
		$self->match('BOL', v => 1);
		given ($self->{t}) {
			when ('PRIKEY') {
				$self->match('PRIKEY');
				$self->match('LPAREN');
				push @ast, ['PRIKEY', $self->getIdentList];
				$self->match('RPAREN');
				$self->match('EOL');
			}
			
			when ('TYPE') {				
				my $ident = $self->getIdent;
				my ($type, @attrs) = $self->getType;
				push @attrs, @{$self->getAttrs};
				$self->match('EOL');
				push @ast, ['MEMBER', $type, $ident, [@attrs]]
			}
			
			default {
				$self->expect('PRIKEY');
			}
		}
	}
	
	return [@ast]
}

sub numOrString {
	my $self = shift;
	
	given ($self->{t}) {
		when ('STRING' or 'INT' or 'UINT') {
			my $ret = [$self->{t}, $self->{v}];
			$self->next;
			return $ret;
		}
		default {
			$self->expect('STRING or NUMBER');
		}
	}	
}

sub getIdentList {
	my $self = shift;
	
	my @ast = ();
	
	push @ast, $self->getIdent;
	
	while ($self->{t} eq 'LISTSEP') {
		$self->match('LISTSEP');
		push @ast, $self->getIdent
	}
	
	return [@ast];
}

sub getAttrs {
	my $self = shift;
	
	my @ast = ();
	
	
	while ($self->{t} eq 'ATTR') {
		my $attr = $self->getAttr;
		my $values = [];
		if ($self->{t} eq 'LPAREN') {
			$self->match('LPAREN');
			$values = $self->getList;
			$self->match('RPAREN');
		}
		push @ast, ['ATTR', $attr, $values];
	}
	
	return [@ast];
}

sub getList {
	my $self = shift;
	
	my @ast = ();
	
	push @ast, $self->numOrString;
	
	while ($self->{t} eq 'LISTSEP') {
		$self->match('LISTSEP');
		push @ast, $self->numOrString
	}
	
	return [@ast];
}

sub getIdent {
	my $self = shift;
	
	unless ($self->{t} eq 'IDENT') {
		$self->expect('IDENT')
	}
	
	my $v = $self->{v};
	
	$self->match('IDENT');
	
	return $v
}

sub getAttr {
	my $self = shift;
	
	unless ($self->{t} eq 'ATTR') {
		die ":) $self->{t}";
		$self->expect('ATTR')
	}
	
	my $v = $self->{v};
	
	$self->match('ATTR');
	
	return $v
}
1;

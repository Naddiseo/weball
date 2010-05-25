package Lexer;

use strict;
use warnings;

use feature ':5.10';

our $VERSION = 2010.05.22;

use Data::Dumper;

#use SymbolTable;

our $punct_rx = qr/[\$~!%^&\*\-\+\=\/\\\|:;\.,?:\(\)\{\}\[\]<>@]/;

sub new {
	my ($c, $fp, $stable) = @_;
	
	my $self = {
#		sym  => $stable,
		fp   => $fp,
		line => 1,
		char => 0,
		
		pushback => undef
	};
	
#	open $self->{fp}, $file or die $!;
	
	return bless $self => $c;
}

sub getChar {
	my $self = shift;
	
	my $c = undef;
	
	if (defined $self->{pushback}) {
		$c = $self->{pushback};
		$self->{pushback} = undef;
		if ($c eq "\n") { $self->{line}-- }
		
	}
	else {
		if (eof($self->{fp})) {
			return undef;
		}

		# $c = getc($self->{fp}) or warn $! && return undef; # doesn't work for some reason
		read ($self->{fp}, $c, 1) or warn $! && return undef;
		$self->{char}++;
	}
	
	given ($c) {
		when ("\r") {
#			return $self->getChar();
		}
		when ("\n") {
			$self->{line}++;
			$self->{char} = 0;
			#say "got NL"
#			return $self->getChar();
		}
		when (/[\s\0]/) {
			#say "got WS '$c' " .  ord($c);
			#$self->{char}++;
#			return $self->getChar();
		}
	}
	#say "C: $c";
	return $c;
}

sub tokenize {
	my $self = shift;
	my @ret = ();
	my $c;
	
	TOKENIZE: until (eof($self->{fp})) {
		 $c = $self->getChar();
		last unless defined $c;
	#	say "given($c)";
		given ($c) {
			when (/_/) {
				$c = $self->getChar();
				if (defined $c and $c eq '_') {
					my $ident = $self->getIdent();
					if ($ident eq 'END') {
						last TOKENIZE;
					}
				}
				else {
					$self->{pushback} = '_';
				}
			}
			when (/^\$/) {
				# local var?
				my $ident = $self->getIdent();
				push @ret, Token->new($self, 'local_ident_t', $ident);
			}
			when (/[a-z_]/i) {
				$self->{pushback} = $c;
				my $ident = $self->getIdent();
				if ($self->isKW($ident)) {
					push @ret, Token->new($self, $ident . '_t', $ident);
				}
				else {
					push @ret, Token->new($self,'ident_t', $ident);
				}
			}
			when (/[0-9]/) {
				$self->{pushback} = $c;

				my $num = $self->getNum();
				push @ret, Token->new($self, 'number_t', $num);
			}
			when (/['"]/) {
				my $q    = $c;
				my $str  = $self->getString($q);
#				my $strN = $self->{sym}->addString($str, $q);
				push @ret, Token->new($self, 'string_t', $str);
			}
			when (/^$Lexer::punct_rx/) {
				$self->{pushback} = $c;
				push @ret, Token->new($self, $self->getPunct(), '');
			}
			when (/[\s\0\r\n]/) {
				# skip the WS
				#say "WS"
			}
			when (/#/) {
				while (defined $c and $c ne "\n") {
					$c = $self->getChar();
				}
			}
			default {
				$self->error("Unknown Lookahead '$c'");
			}
		}
	}
	
	#say "tokenize() exiting with '$c'";
	
	push @ret, Token->new($self, '', ''); #['', undef];
	
	return @ret;
}


sub getString {
	my ($self, $q) = @_;
	
	my $ret = '';
	my $b = 1;

	LOOP: while ($b) {
		my $c = $self->getChar();
		unless (defined $c) {
			$self->error("End of File reached before end of string");
		}
		
		given ($c) {
			when (/$q/) {
				$b = 0; # exit the given and while loop
			}
			when (/[^\\$q]/) {
				$ret .= $c
			}
			when (/\\/) {
				$c = $self->getChar();
				unless (defined $c) {
					$self->error("End of File reached before end of string");
				}
				$ret .= $c;
			}
			default {
				$self->error("Unknown sequence in string '$c'");
			}
		}
	}
	
	return $ret;
}

sub getNum {
	my ($self) = @_;
	#say "pb: $self->{pushback}";
	my $c     = $self->getChar();
	my $ret   = '';
	my $isHex = 0;
	
	#say "c: $c";
	
	if ($c eq '0') {
		$c = $self->getChar();
		return '0' unless (defined $c);
		$ret = '0';
		if ($c eq 'x') {
			$ret = '0x';
			$isHex = 1;
			$c = $self->getChar();
			return '0' unless (defined $c);
		}
		
		#say "$ret $isHex $c";
	}
	
	LOOP: 
	while (1) {
		if ($c =~ /[0-9]/ or ($isHex and $c =~ /[a-f]/i)) {
			$ret .= $c;
		}
		else {
			$self->{pushback} = $c;
			last LOOP;
		}
		
		$c = $self->getChar();
		unless (defined $c) {
			$self->error("Error reading number");
		}
	}
	
	return $ret
}

sub getPunct {
	my $self = shift;
	my $ret  = '';
	my $c    = $self->getChar();
	my %punct = map { $_ => 1 } (
		'<<=', '>>=',
		'~=', '^=', '&=', '|=',
		'*=', '-=', '+=', '/=', '%=',
		'<<', '>>', '--', '++', '**',
		'==', '!=',	'<=', '>=',
		'<', '>', '||', '&&', '->',
		'+', '-', '*', '/', '%',
		'~', '^', '&', '|',
		'!', '?', ':', '.', ';', ',', 
		'(', ')', '{', '}', '[', ']',
		'=', '$', '@'
	);
	
	while ($c =~ /$Lexer::punct_rx/ and $punct{$ret . $c}) {
		$ret .= $c;
		defined($c = $self->getChar()) or last;
	}
	#say "exiting with '$c'";
	$self->{pushback} = $c;
	
	return $ret;
}

sub getIdent {
	my ($self) = @_;

	my $c   = $self->getChar();
	my $ret = $c;
	#say "ret:$ret";
	unless ($c =~ /[a-z_]/i) {
		$self->error("expected ident");
	}
	
	LOOP:
	while (1) {
		defined($c = $self->getChar()) or last LOOP;
		if ($c =~ /[a-z_0-9]/i) {
			$ret .= $c;
			#say "ret:$ret";
		}
		else {
			$self->{pushback} = $c;
			last LOOP;
		}
	}
	
	return $ret;
}

sub isKW {
	my ($self, $ident) = @_;
	
	my %kw = map {
		$_ => 1
	} (
		'for', 'if', 
		'else', 'elseif', 
		'and', 'or', 'not', 'xor', 
		'while', 'function',
		'goto', 'return',
		'class', 'template',
		'true', 'false',
		'uint', 'int', 'string', 'double', 'bool'
	);
	
	return exists($kw{$ident}) and $kw{$ident} == 1
}

sub error {
	my ($self, $msg) = @_;
	
	die "Lexer error [$self->{line}:$self->{char}]: $msg";
}

1;
package Token;
use strict;
use warnings;

sub new {
	my ($c, $lexer, $type, $text) = @_;
	
	my $self = {
		line  => $lexer->{line},
		char  => $lexer->{char},
		len   => length($text),
		value => $text,
		type  => $type,
	};
	
	bless $self => $c;
}

sub line  { shift->{line } }
sub char  { shift->{char } }
sub len   { shift->{len  } }
sub type  { shift->{type } }
sub value { shift->{value} }

1;

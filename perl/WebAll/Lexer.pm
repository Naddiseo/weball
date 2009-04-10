package WebAll::Lexer;

use strict;
use warnings;

use 5.010;

our $VERSION 		= '2.0.0';

my $rxIdent			= qr/[a-z_][a-z0-9_]*/i;
my $rxUInt 			= qr/\d+/;
my $rxInt			= qr/-?$rxUInt/;
my $rxFloat			= qr/$rxInt\.$rxUInt/;
my $rxNum 			= qr/$rxInt(?:\.$rxUInt)?/;

sub new {
	my ($c, %args) = @_;
	$c = ref $c || $c;
	
	my $self = {
		text => [],
		line => '',
		lineN => 0,
		lastLineLength => 0,
	};
	
	if ($args{file}) {
		open my $fh, $args{file} or die $!;
		# Slurpy()
		$args{text} = do { local $/; <$fh> };
		close $fh;
	}
	# Need to split it
	
	# Remove those stupid \r
	$args{text} =~ s/\r\n/\n/g;
	$args{text} =~ s/\r/\n/g;
	
	# All Windows/Mac line breaks should be *nix breaks now
	$self->{text} = [split /\n/, $args{text}];
	
	bless $self => $c;
}


=head2 getLine()

Grabs a line from the text, and increments the line counter.

=cut

sub getLine {
	my $self = shift;
	
	# Keep track of the length of the previous line
	$self->{lastLineLength} = length ($self->{line} || '');
	
	# grab the next line
	$self->{line} = shift @{$self->{text}};
	
	# and increment the line number
	$self->{lineN}++ if $self->{line}
}

=head2 lineData($$)

 int $pos     := the current position of \G
 int $length  := length of the token

Calculates the starting position of a token given the current position, and
the length of the token.

=cut

sub lineData {
	my ($self, $pos, $len) = @_;
	
	# EOL will make this undef
	$pos ||= 0;
	$pos -= $len;
	
	# For EOL, it was on the previous line
	if ($pos < 0) {
		return ($self->{lineN} - 1 , $self->{lastLineLength} - $pos);
	}
	
	return ($self->{lineN}, $pos);
}

sub yylex {
	my $self = shift;	
	
	# Make sure we have text to proces
	unless ($self->{line}) {
		$self->getLine
	}
	
	# I would really like to use 5.10's given/when structure.
	# get the tokens out of the current line
	for ($self->{line}) {
		
		when (!defined) {
			next
		}
		
		# Kill null lines
		when (/^\s*$/) {
			$self->getLine;
			redo;
		}
		
		# if we've reached the end of the line
		when (/\G$/cgox)  {
			$self->getLine;
			return ['EOL', '', $self->lineData(pos($self->{line}), 1)];
		}
		
		# Initial tabs
		when (/\G^(\t+)/cgox) {
			return ['BOL', length($1), 0, 0]
		}
		
		# Kill whitespace
		when (/\G\s+/cgox) {
			redo
		}
		
		# Match comments
		when (/\G(\#.*)$/cgox) {
			return [
				'COMMENT', 
				$1,
				$self->lineData(pos($self->{line}), length($1))
			];
		}
		
		# Strings
		when (/\G(['"])/cgox) {
			my $b = $1;
			my $pos = pos($self->{line});
			my $s = '';
			
			while (1) {
				if (/\G$/cgox) {
					die "String's cannot span multiple lines";
				}
				elsif (/\G([^\\$b]*)/cgox) {
					$s .= $1;
				}
				elsif (/\G(\\.)/cgox) {
					# escape sequence
					$s .= $1
				}
				elsif (/\G$b/cgox) {
					last;
				}
				else {
					die "Shouldn't get here";
				}				
			}
			return [
				'STRING',
				$s,
				$self->lineData($pos, 0)
			]	
		}
		
		# numbers
		when (/\G(-?\d+(?:\.\d+)?)/cgox) {
			my $n = $1;
			my $type = 'INT';
			if ($n !~ /^\-/) {
				$type = "U$type"
			}
			if ($n =~ /\./) {
				$type = 'FLOAT'
			}
			
			return [
				$type,
				$n,
				$self->lineData(pos($self->{line}), length($n))
			]
		}
		
		# Keywords
		when (/\G^class\s+($rxIdent)\s*$/cgox) {
			return [
				'CLASS',
				$1,
				$self->lineData(pos($self->{line}), length($1))
			]
		}
		
		
		when (/\G^page\s+($rxIdent)\s*$/cgox) {
			return [
				'PAGE',
				$1,
				$self->lineData(pos($self->{line}), length($1))
			]
		}
		
		
		when (/\G^type\b/cgox) {
			return [
				'TYPEDEF',
				'',
				$self->lineData(pos($self->{line}), 4)
			]
		}
		
		when (/\G(int|uint|string|bool|float)\b/cgox) {
			return [
				'TYPE',
				$1,
				$self->lineData(pos($self->{line}), length($1))
			]
		}
		
		when (/\Gpk\b/cgox) {
			return [
				'PRIKEY',
				'',
				$self->lineData(pos($self->{line}), 2)
			]
		}
		
		# L Paren
		when (/\G\(/cgox) {
			return [
				'LPAREN', 
				'', 
				$self->lineData(pos($self->{line}), 1)
			];
		}
		
		# R Paren
		when (/\G\)/cgox) {
			return [
				'RPAREN', 
				'', 
				$self->lineData(pos($self->{line}), 1)
			];
		}
		
		# min-max range
		when (/\G(\[\s*($rxNum)\s*:\s*($rxNum)\s*\])/cgox) {
			return [
				'MINMAX', 
				[$2, $3], 
				$self->lineData(pos($self->{line}), length($1))
			]
		}
		
		# max range
		when (/\G(\[\s*($rxNum)\s*])/cgox) {
			return [
				'MAX',
				$2,
				$self->lineData(pos($self->{line}), length($1))
			]
		}
		
		# attributes
		when (/\G:($rxIdent)/cgox) {
			return [
				'ATTR',
				$1,
				$self->lineData(pos($self->{line}), length($1))
			];
		}
		
		# Identifiers (variables)
		when (/\G($rxIdent)/cgox) {
			return [
				'IDENT', 
				$1, 
				$self->lineData(pos($self->{line}), length($1))
			];
		}
		
		# Error on anything else
		when (/\G(\S+)/cgox) {
			die(
				# maybe I'm missing something.. isn't there a better way to do
				# this without sprintf() ?
				sprintf(
					"Lexer Error: unknown token '%s' at %d: %d",
					$1,
					$self->lineData(pos($self->{line}), length($1))
				)
			);
		}
		
	}
	
	# If we get here, can assume we reached the end
	return ['EOF', 'EOF' ,$self->lineData(pos($self->{line}), 1)];
}

1;

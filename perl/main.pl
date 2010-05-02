#!/usr/bin/perl

use strict;
use warnings;
use feature ':5.10';

use Data::Dumper;
use Getopt::Long;
use Pod::Usage;

#$Data::Dumper::Indent = 1;

use Lexer;
use Parser;


my $exit_status = 1;
my $opt_help    = 0;
my $input_file  = '';
#my $PP_only     = 0;
my $output      = '';
my $output_fh   = undef;
my $debug_flag  = 0;

my @tokens = ();

GetOptions(
	'help|?' => \$opt_help,
#	'P'      => \$PP_only,
	'o'      => \$output,
	'd'      => \$debug_flag
) or pod2usage();
$opt_help and pod2usage();

$input_file = shift @ARGV;

pod2usage() unless $input_file and -f $input_file;

sub main {
	open my $fh, $input_file or die $!;

	#my $text = PP->new($fh)->preprocess($fh);
	#goto success if $PP_only;
	#say $text;

	#my $text = do {local $/; <$fh> };
	my $l = Lexer->new($fh);

	@tokens = $l->tokenize();
	#die "gets here";
	my $parser = Parser->new;
	my $result = $parser->YYParse(
		yylex => \&yylex,
		yydebug => $debug_flag,
		yyerror => \&yyerror
	);

	say Dumper($result);

success:
	close $fh;	

	# Set exit status to success
	$exit_status = 0;
}

main() and exit($exit_status);


sub yylex {
	my $p = shift;
	
	#my ($t, $v) = @{shift(@tokens)};
	my $tok = shift @tokens;
	my $t = $tok->{type};
	my $v = $tok;
	unless (defined $t) {
		die "t is undef";
	}

	say STDERR "giving ($t, $v)" if defined $v and $debug_flag eq 'l';
	
	return ($t, $v);
}

sub yyerror {
	my $parser = shift;

	die 'Parser [' . 
		$parser->YYCurval->line . ':' .
		$parser->YYCurval->char . ']: Expected ' . 
		join(', or ', $parser->YYExpect) . ' got "' . $parser->YYCurtok . '"';

	die Dumper $parser->YYCurtok, $parser->YYCurval, $parser->YYExpect, $parser->YYSemval(1);
}

__END__


=head1 NAME

Lang 2

=head1 USAGE

hihi

=head1 SYNOPSYS

hihi2

=head1 DESCRIPTION



=head1 EXAMPLE



=head1 LICENSE

Copyright (C) 2010 Richard Eames.
This module may be modified, used, copied, and redistributed at your own risk.
Publicly redistributed modified versions must use a different name.


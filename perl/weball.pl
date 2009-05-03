#!/usr/bin/perl

use strict;
use warnings;

use 5.010;

use FindBin;
use lib($FindBin::Bin);

use File::Path;
use File::Basename;
use Getopt::Long;

# takes care of the lexing and parsing for now.
use JSON -support_by_pp;

use WebAll::Semantic;

use WebAll::SQL;
#use WebAll::Semantic;

use Data::Dumper;

my ($input, $htmldir, $outdir, $libdir, $dbname, $dbuser, $dbpassword);
my @languages = ();

GetOptions(
	'input=s' => \$input,
	'htmldir=s' => \$htmldir,
	'outdir=s' => \$outdir,
	'lib=s' => \$libdir,
	'dbname=s' => \$dbname,	
	'u=s' => \$dbuser,
	'p=s' => \$dbpassword,
	'lang=s' =>\@languages,
);

die 'No Input' unless $input;

die 'No output dir' unless $outdir;
die 'No DB' unless $dbname;
die 'No username' unless $dbuser;
$dbpassword = '' unless $dbpassword;





open FILE, $input or die $!;
my $json = do { local $/; <FILE> };
close FILE;

my $j = new JSON;
$j->relaxed(1);
$j->allow_singlequote(1);
$j->allow_barekey(1);

my $perl = $j->decode($json);

WebAll::Semantic::process($perl);
print Dumper($perl);

WebAll::SQL::process($perl, libdir => $libdir, dbname => $dbname, dbuser => $dbuser, dbpassword => $dbpassword);



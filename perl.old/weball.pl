#!/usr/bin/perl
use strict;
use warnings;
use 5.10.0;
use File::Path;
use Getopt::Long;

use FindBin;
use lib($FindBin::Bin);

use Parser;
use PHP;


my ($file, $htmldir, $outdir, $libdir, $db, $username, $password);

GetOptions(
	'file=s' => \$file,
	'htmldir=s' => \$htmldir,
	'outdir=s' => \$outdir,
	'lib=s' => \$libdir,
	'dbname=s' => \$db,	
	'u=s' => \$username,
	'p=s' => \$password,
);

die 'No Input' unless $file;
die 'No output dir' unless $outdir;
die 'No DB' unless $db;
die 'No username' unless $username;
$password = '' unless $password;

mkpath(
	"$libdir/sql/functions",
	"$libdir/sql/procs",
	"$libdir/sql/tables",
	"$libdir/dbinterface",
	"$libdir/core",
	"$libdir/pages",
	"$libdir/templates",
	"$libdir/config",
);

my $p = new Parser($file);

my @classes = $p->getClasses;
my @types = $p->getTypes;
my %roles = $p->getRoles;
my %dbfns = $p->getDBFunctions;
my %config = $p->getConfig;
my @pages = $p->getPages;

my $php = new PHP(
	outdir => $outdir,
	classes => [@classes],
	pages => [@pages],
	dbfunctions => {%dbfns},
	db => $db,
	username => $username,
	password => $password,
	config => {%config},
	libdir => $libdir,
	htmldir => $htmldir,
	
);

use Data::Dumper;
for my $p (@pages) {
	#print STDERR Dumper($p);
}

$php->copyCore;
$php->frontend;
$php->dbinterface;
$php->config;

#for my $t(@types) {
#	print $t->printDBCreate;
#}

#for my $r (keys %roles) {
#	say "Role $r : $roles{$r}";
#}


while (my ($scope, $fn) = each %dbfns) {
	open my $FH, ">$libdir/sql/functions/$fn->{name}.sql" or die $!;
	my $str = $fn->printme;
	$str =~ s/#db#/$db/g;
	say $FH $str;
	close $FH;
}

for my $c (sort @classes) {
	open my $FH, ">$libdir/sql/tables/$c->{name}.sql" or die $!;
		my $str = $c->printDBCreate;
		$str =~ s/#db#/$db/g;
		say $FH $str;
	close $FH;
	open $FH, ">$libdir/sql/procs/$c->{name}.sql" or die $!;
		$str = $c->printCRUD;
		$str =~ s/#db#/$db/g;
		say $FH $str;
	close $FH;
}

open my $sqlinstall, ">$libdir/sql/install.sh" or die $!;
say $sqlinstall <<EOF;
#!/bin/bash
cd $libdir/sql/

echo "delimiter //" > install.sql
cat tables/*.sql >> install.sql
cat procs/*.sql >> install.sql
cat functions/*.sql >> install.sql
echo "" >> install.sql

mysql -u$username -p$password $db < install.sql

EOF
chmod 0744, "$libdir/sql/install.sh";

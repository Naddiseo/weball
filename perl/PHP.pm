package PHP;

use strict;
use warnings;
use 5.10.0;
use File::Copy;


sub new {
	my $class = shift;
	my %args = @_;
	
	my $self = {
		outdir => $args{outdir},
		classes => $args{classes},
		dbfunctions => $args{dbfunctions},
		db => $args{db},
		username => $args{username},
		password => $args{password},
		config => $args{config},
	};
	
	bless $self, $class;
}

sub config {
	my $self = shift;
	
	open my $fh, ">$self->{outdir}/config/Config.php" or die $!;
	say $fh "<?\nstatic \$MSQL_NUM_QUERIES = 0;";
	
	for my $k (sort keys %{$self->{config}}) {
		say $fh "define('$k', '$self->{config}{$k}');"
	}

	print $fh <<EOF;
require_once('core/Exceptions.php');

//session
define('SESSION_PUBLIC', 1);
define('SESSION_USER', 2);

?>
EOF
	close $fh;
}

sub dbinterface {
	my $self = shift;
	
	for my $c (@{$self->{classes}}) {
		open my $fh, ">$self->{outdir}/dbinterface/i$c->{name}.php" or die $!;
		say $fh <<EOF;
<?
require_once('config/Config.php');
require_once('core/Base.php');

class i$c->{name} extends BaseClass {	
EOF
		
		for my $arg (@{$c->{members}}) {
			my $def = $arg->printDefString;
			say $fh "\tpublic \$$arg->{name} = $def;";
		}
		
		say $fh "\n\tpublic function\n\treset() {";
		for my $arg (@{$c->{members}}) {
			my $def = $arg->printDefString;
			say $fh "\t\t\$$arg->{name} = $def;";
		}
		say $fh "\t\treturn \$this->update();\n\t}\n";
		
		say $fh "\tpublic function\n\tget(" . join(', ', (map { "\$$_" } @{$c->{pk}})) . ") {";
		say $fh "\t\treturn parent::get(" . join(', ', (map { "\$$_" } @{$c->{pk}})) . ");\n\t}\n\n";
		
		say $fh "\tpublic function\n\tdelete() {";
		say $fh "\t\treturn parent::delete(" . join(', ', (map { "\$this->$_" } @{$c->{pk}})) . ");\n\t}\n";
		
		say $fh "\tpublic function\n\tinsert() {";
		say $fh "\t\treturn parent::insert(\n\t\t\t" . 
			join(",\n\t\t\t", (map { "\$this->$_->{name}" } $c->getNonePKMembers())) . "\n\t\t);\n\t}\n";
		
		
		say $fh "\tpublic function\n\tupdate() {";
		say $fh "\t\treturn parent::update(\n\t\t\t" . 
			join(",\n\t\t\t", (map { "\$this->$_->{name}" } @{$c->{members}})) . "\n\t\t);\n\t}\n";
		
		for my $fn (@{$c->{dbfn}}) {
			say $fh $fn->getPHP;
		}
		
		print $fh "}\n?>";
		close $fh;
	}
}


sub copyCore {
	my $self = shift;
	
	for my $f (qw(Base Cache Db Email Exceptions Page Security Session Template)) {
		copy("./PHP/core/$f.php", "$self->{outdir}/core/$f.php");
	}
}
1;

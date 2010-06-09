package Analysis::Attribute;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

our $VERSION = 2010.06.08;

sub new { carp __PACKAGE__ . " does have new()" }

sub analyse {
	my ($astSym) = @_;
	
	my $ret = undef;
	my $ast = $astSym->{ast};
	delete $astSym->{ast};
	
	#die Dumper $ast;
	
	$astSym->{argc} = scalar @{$ast->{args}};
	
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

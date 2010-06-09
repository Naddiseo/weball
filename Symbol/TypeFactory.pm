package Symbol::TypeFactory;
use strict;
use warnings;
use feature ':5.10';
use Carp;

our $VERSION = 2010.06.08;

use Symbol::Type;
use Symbol::Type::Bool;
use Symbol::Type::Double;
use Symbol::Type::Int;
use Symbol::Type::String;
use Symbol::Type::UInt;
use Symbol::Type::Undef;
use Symbol::Type::Unresolved;

sub new {
	carp __PACKAGE__ . " does have new()"
}

sub createType {
	my ($type, @args) = @_;

	my $ret = undef;

	given ($type) {
		when ('Bool') {
			$ret = Symbol::Type::Bool->new(@args);
		}
		when ('Double') {
			$ret = Symbol::Type::Double->new(@args);
		}
		when ('Int') {
			$ret = Symbol::Type::Int->new(@args);
		}
		when ('String') {
			$ret = Symbol::Type::String->new(@args);
		}
		when ('UInt') {
			$ret = Symbol::Type::UInt->new(@args);
		}
		when ('Undef') {
			$ret = Symbol::Type::Undef->new(@args);
		}
		when ('Unresolved') {
			$ret = Symbol::Type::Unresolved->new(@args);
		}
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

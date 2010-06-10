package Analysis::Attribute;
use strict;
use warnings;
use feature ':5.10';
use Carp;

use Data::Dumper;

our $VERSION = 2010.06.10;

use Symbol::Type;
use Symbol::TypeFactory;

sub new { carp __PACKAGE__ . " does have new()" }

sub analyse {
	my ($astSym) = @_;
	
	my $ret = undef;
	my $ast = $astSym->{ast};
	delete $astSym->{ast};
	
	#die Dumper $ast;
	
	$astSym->{argc} = scalar @{$ast->{args}};
	
	for my $arg (@{$ast->{args}}) {
		# XXX: for now, only accept primitive
		if (ref $arg ne 'AST::Primitive') {
			carp "Arguments for attributes can only be primitives";
		}
		
		my $type = Symbol::Type::getTypeFromPrimitive($arg);
		
		push @{$astSym->{argv}}, Symbol::TypeFactory::createType($type, $arg->value);
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

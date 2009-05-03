package WebAll::Semantic;

use strict;
use warnings;

use 5.010;

use Storable qw/thaw freeze/;

my %types = ();

sub process {
	my $code = shift;
	
	processTypedefs($code->{typedefs});
	delete $code->{typedefs};
	processClassMembers($code->{classes});
	
	return $code;
}

sub processTypedefs {
	my %td = %{shift()};
	
	while (my ($name, $attrs) = each %td) {
		$types{$name} = $attrs;
	}
}

sub processClassMembers {
	my $classes = shift;
	
	for my $classN (keys %$classes) {
		my $class = $classes->{$classN};
		
		my %pk = ();
		
		if ($class->{pk}) {
			for my $ival (@{$class->{pk}}) {
				if ($ival->[0] eq $classN) {
					$pk{$ival->[1]} = 1;
				}
			}
		}
		
		for my $member (@{$class->{members}}) {
			my ($memberName, $attrs) = @$member;
			
			my $type = $attrs->{type};
			
			if ($types{$type}) {
				for my $attrName (keys %{$types{$type}}) {
					my $attrCopy = thaw(freeze($types{$type}));
					
					unless (exists $attrs->{$attrName}) {
						$member->[1]{$attrName} = $attrCopy->{$attrName}
					}
					$member->[1]{type} = $attrCopy->{type}
				}
			}
			
			if ($pk{$memberName}) {
				$attrs->{pk} = 1;
			}
			
			unless ($attrs->{default}) {
				given ($attrs->{type}) {
					when (/bool|uint|int/) {
						$attrs->{default} = 0;
					}
					when ('string') {
						$attrs->{default} = '';
					}
					when (/float|double/) {
						$attrs->{default} = 0.0;
					}
				}
			}
		}
	}
}



1;

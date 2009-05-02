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
		
		for my $memberName (keys %{$class->{members}}) {
			my $member = $class->{members}{$memberName};
			my $type = $member->{type};
			
			if ($types{$type}) {
				for my $attrName (keys %{$types{$type}}) {
					my $attrCopy = thaw(freeze($types{$type}));
					
					unless (exists $member->{$attrName}) {
						$classes->{$classN}{members}{$memberName}{$attrName} = $attrCopy->{$attrName}
					}
					$classes->{$classN}{members}{$memberName}{type} = $attrCopy->{type}
				}
			}
			
			unless ($member->{default}) {
				given ($member->{type}) {
					when (/bool|uint|int/) {
						$member->{default} = 0;
					}
					when ('string') {
						$member->{default} = '';
					}
					when (/float|double/) {
						$member->{default} = 0.0;
					}
				}
			}
		}
	}
}



1;

package Class;

use strict;
use warnings;
use Member;

sub new {
	my ($c, $name) = @_;
	
	my $self = {
		name => $name,
		members => [],
		indexes => [],
		membersByName => {},
		pk => [],
	};
	
	bless $self, $c;
}

sub addMember {
	my ($self, $member) = @_;
	
	push @{$self->{members}}, $member;
	$self->{membersByName}{$member->{name}} = $member;
	return $self;
}

sub getMember {
	my ($self, $n) = @_; 
	return $self->{membersByName}{$n};
}

1;

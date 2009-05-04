package WA;
use strict;
use warnings;

use 5.010;


sub parseArgs {
	@_
}

1;
__END__


	# Strings
		when (/\G(['"])/cgox) {
			my $b = $1;
			my $pos = pos($self->{line});
			my $s = '';
			
			while (1) {
				if (/\G$/cgox) {
					die "String's cannot span multiple lines";
				}
				elsif (/\G([^\\$b]*)/cgox) {
					$s .= $1;
				}
				elsif (/\G(\\.)/cgox) {
					# escape sequence
					$s .= $1
				}
				elsif (/\G$b/cgox) {
					last;
				}
				else {
					die "Shouldn't get here";
				}				
			}
			return [
				'STRING',
				$s,
				$self->lineData($pos, 0)
			]	
		}
1;
__END__

sub class {}
sub member {}
sub end {}

sub bool {}
sub int {}
sub uint {}
sub string {}
sub float {}


sub auto_increment {}

sub default {}

sub email_t {}

sub password_t {}


sub pk {}
sub index {}

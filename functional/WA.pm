package WA;
use strict;
use warnings;

use 5.010;


sub parseArgs {
	my $line = shift;
	
	my @ret = ();
	
	for ($line) {
		last if m/^\s*$/cgox or m/\G$/cgox;
		
		when (/\G\s+/cgox) {
			redo
		}
		
		when (/\G(-?\d+(?:\.\d+)?)/cgox) {
			push @ret, $1;
			redo
		}
		
		when (/\G([a-z][a-z0-9_-]*)/cgoix) {
			push @ret, "'$1'";
			redo
		}
		
	
		when (/\G(['"])/cgox) {
			my $b = $1;
			my $s = '';
			
			STRING: while (1) {
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
					last STRING;
				}
				else {
					die "Shouldn't get here";
				}				
			}
			push @ret, $b . $s . $b;
			redo
		}
	}
	
	return @ret;
}

1;
__END__

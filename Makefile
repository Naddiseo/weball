
all:
	clear
	yapp -v  -oParser.pm -m Parser weball.yp
	perl -I. -W main.pl test.txt
	
debug:
	clear
	yapp -v  -oParser.pm -m Parser weball.yp
	perl -I. -W main.pl -d 31 test.txt

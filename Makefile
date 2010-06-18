
all:
	clear
	yapp -v  -oParser.pm -m Parser weball.yp
	#TODO: add the 'outdir' option to the main program
	mkdir -pv ./out/
	perl -I. -W main.pl -o=out/ test.txt
	
debug:
	clear
	yapp -v  -oParser.pm -m Parser weball.yp
	mkdir -pv ./out/
	perl -I. -W main.pl -d 31 test.txt

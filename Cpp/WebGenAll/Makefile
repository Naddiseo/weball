export LC_ALL=en_CA.utf8
OPTIONSD=-I. -I/usr/include -DNDEBUG=2 -g -ansi -Wall -W -Wfatal-errors -pedantic -pedantic-errors -Wmain
OPTIONSR=-I. -I/usr/include -O3 -ansi -Wall -W -Wfatal-errors -pedantic -pedantic-errors -Wmain

TESTFILE=../../../ww2_trunk/ww2_trunk.all

lex:
	flex -B lexer.l
	
bison:
	bison -vtd parser.y

Debug: bison lex
	g++ -I. -I/usr/include -g -W -c parser.tab.c -o ./bin/parser.o
	g++ -I. -I/usr/include -g -W -c lexer.c -o ./bin/lexer.o
	g++ $(OPTIONSD) -o ./bin/Config.o -c Config.cpp
	g++ $(OPTIONSD) -o ./bin/main.o -c main.cpp
	g++ ./bin/*.o -o ./bin/WebGenAll
	
Release: lex bison
	g++ $(OPTIONSR) -o ./obj/Release/main.o -c main.cpp
	g++ $(OPTIONSR) -o ./obj/Release/defs.o -c defs.cpp
	
all: Debug

clean:
	-rm lexer.[ch] parser.tab.[ch] parser.output ./bin/*.o

cleanDebug:
	- rm ./obj/Debug/* ./bin/Debug/*
	

cleanRelease:
	- rm ./obj/Debug/* ./bin/Debug/*

run:
	./bin/WebGenAll -d $(TESTFILE)

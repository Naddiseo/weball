
OPTIONSD=-I. -I/usr/include -DNDEBUG=2 -g -ansi -Wall -W -Wfatal-errors -pedantic -pedantic-errors -Wmain
OPTIONSR=-I. -I/usr/include -O3 -ansi -Wall -W -Wfatal-errors -pedantic -pedantic-errors -Wmain


lex:
	flex --header-file=lex.yy.h lex.l
	g++ -I. -I/usr/include -g -W -c lex.yy.c -o ./obj/Debug/lex.o
	
bison:
	bison -vtd grammar.y
	g++ -I. -I/usr/include -g -W -c grammar.tab.c -o ./obj/Debug/grammar.o

Debug: lex bison
	g++ $(OPTIONSD) -o ./obj/Debug/main.o -c main.cpp
	g++ $(OPTIONSD) -o ./obj/Debug/defs.o -c defs.cpp
	g++ ./obj/Debug/*.o -o ./bin/Debug/WebGenAll
	
Release: lex bison
	g++ $(OPTIONSR) -o ./obj/Release/main.o -c main.cpp
	g++ $(OPTIONSR) -o ./obj/Release/defs.o -c defs.cpp
	
all: Debug


cleanDebug:
	- rm ./obj/Debug/* ./bin/Debug/*
	

cleanRelease:
	- rm ./obj/Debug/* ./bin/Debug/*

export LC_ALL=en_CA.utf8
OPTIONSD=-I. -I/usr/include -DNDEBUG=1 -g -ansi -Wall -W -Wfatal-errors -pedantic -pedantic-errors -Wmain
OPTIONSR=-I. -I/usr/include -O3 -ansi -Wall -W -Wfatal-errors -pedantic -pedantic-errors -Wmain

TESTFILE=../../../ww2_trunk/ww2_trunk.all
TESTFILE=./test_td.all
TESTFILE=./test_class.all

all: bison lex
	g++ $(OPTIONSD) -o ./bin/Config.o -c Config.cpp
	g++ $(OPTIONSD) -o ./bin/Class.o -c Class.cpp
	g++ $(OPTIONSD) -o ./bin/ClassMember.o -c ClassMember.cpp
	g++ $(OPTIONSD) -o ./bin/Type.o -c Type.cpp
	g++ $(OPTIONSD) -o ./bin/TypeValue.o -c TypeValue.cpp
	g++ $(OPTIONSD) -o ./bin/Attribute.o -c Attribute.cpp
	g++ $(OPTIONSD) -o ./bin/Program.o -c Program.cpp
	g++ $(OPTIONSD) -o ./bin/IVal.o -c IVal.cpp
	g++ $(OPTIONSD) -o ./bin/error.o   -c error.cpp
	g++ $(OPTIONSD) -o ./bin/misc.o   -c misc.cpp
	g++ $(OPTIONSD) -o ./bin/main.o -c main.cpp
	g++ ./bin/*.o -o ./bin/WebGenAll

lex:
	#flex -B lexer.l
	#g++ -I. -I/usr/include -g -W -c lexer.c -o ./bin/lexer.o
	g++ $(OPTIONSD) -o ./bin/lexer.o -c lexer.cpp
	
bison:
	bison --report=state,lookahead,itemset -vtd parser.y
	g++ -I. -I/usr/include -g -W -c parser.tab.c -o ./bin/parser.o

clean:
	-rm lexer.[ch] parser.tab.[ch] parser.output ./bin/*.o valgrind.out


run_debug:
	./bin/WebGenAll -d $(TESTFILE)
	
run:
	./bin/WebGenAll $(TESTFILE)

memcheck:
	valgrind ./bin/WebGenAll $(TESTFILE)

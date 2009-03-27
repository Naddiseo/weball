all: flex bison
	gcc -I . grammar.tab.c lex.yy.c main.c weball_fn.c hash.c -o weball -lfl 2>gcc.log

flex:
	flex --header-file=lex.yy.h lex.l

bison:
	bison -vtd grammar.y

debug: flex bison
	gcc -I . -g -DYYDEBUG=1 -DNDEBUG=1 \
	grammar.tab.c lex.yy.c main.c weball_fn.c hash.c -o weball -lfl 2>gcc.log

clean:
	-rm valgrind.out grammar.output lex.yy.h \
	grammar.tab.c lex.yy.c weball grammar.tab.h gcc.log \
	out
	
buckettest:
	gcc -I. -g -Wall  test_hash.c hash.c -o test_hash

run:
	./weball test.all

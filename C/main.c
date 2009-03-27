#include <stdio.h>
#include <string.h>
#include <hash.h>


extern FILE *yyin;
extern FILE *yyout;
extern int yydebug;
extern int yyparse();

unsigned int cline;

/* ------- */

int
main(int argc, const char * argv[]) {

	cline = 1;

#ifdef NDEBUG
	yydebug = 1;
#endif

	if(argc >= 2) {
		int x;
		for(x = 1; x < argc; x++ ) {
			if(!strncmp(argv[x], "-d", 2)) {
				yydebug = 1;
			} else {
				yyin = fopen(argv[x], "r");
				if(!yyin) {
					printf("Could not use file %s for input, using stdin\n", argv[x]);
				} else {
					printf("Using file %s for input\n", argv[x]);
				}
				break;
			}
		}
	}
	
	if (!init_weball_fn()) {
		fprintf(stderr, "Could not initialize\n");
		return -1;
	}
	
	while(yyparse() == 0) {
		//Parser::root->print(0);
		//Parser::root->delete_r();
		
	}
	
	
	if(yyin != stdin) fclose(yyin);
	if(yyout != stdout) fclose(yyout);
	
	if (!deinit_weball_fn()) {
		fprintf(stderr, "Could not deinitialize\n");
		return -1;
	}

}

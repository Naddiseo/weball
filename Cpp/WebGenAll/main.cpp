#include <config.h>
#include <iostream>
#include <cstring>
#include <libgen.h> // for dirname()
#include <lexer.hpp>
#include <Program.hpp>

extern "C" {
	int yyparse();
}

extern int yydebug;

Program p;

int main (int argc, char* argv[]) {
	
	FILE* in = NULL;
	FILE* out = NULL;

#ifdef NDEBUG 
	std::cerr << "Setting debug\n";
	yyset_debug (1);
	//yydebug = 1;
#endif

	string basedir = "";

	if (argc >= 2) {
		int x;
		 for (x = 1; x < argc; x++) {
			std::cerr << "processing " << argv[x] << std::endl;
			if (strncmp (argv[x], "-d", 2) == 0) {
				std::cerr << "Setting debug\n";
				//yyset_debug (1);
				//yydebug = 1;
			} else {
				in = fopen (argv[x], "r");
				if (in == NULL) {
					std::cerr << "Could not use file " << argv[x] << " for input, using stdin" << std::endl;
				} else {
					std::cerr << "Using file " << argv[x] << " for input" << std::endl;
					basedir.assign(dirname(argv[x]));
					basedir.append("/");
					std::cerr << "basedir = " << basedir << std::endl;
					yyset_baseDirectory(basedir);
					yyset_in (in);
					break;
				}
			}
		}
	}
	lex_init();
	yyparse();
	std::cout << std::endl;
	p.print();

	// clean up
	killStrings();

	if (in != NULL && in != stdin) {
		fclose (in);
	}
	if (out != NULL && out != stdout) {
		fclose (out);
	}

	return 0;
}

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
	
	FILE* out = stdout;

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
				yydebug = 1;
			} else {
				string input = argv[x];
				basedir.assign(dirname(argv[x]));
				basedir.append("/");
				std::cerr << "basedir = " << basedir << std::endl;
				yyset_baseDirectory(basedir);
				std::cerr << "found input file " << input <<std::endl;
				includeFile(input);
				
			}
		}
	}
	lex_init();
	yyparse();
	std::cout << std::endl;
	p.print();

	// clean up
	killStrings();

	if (out != NULL && out != stdout) {
		fclose (out);
	}

	return 0;
}

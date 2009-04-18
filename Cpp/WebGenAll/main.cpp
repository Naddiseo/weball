#include <config.h>
#include <iostream>
#include <string>
#include <cstring>
#include <libgen.h> // for dirname()
#include <lexer.h>
#include <Program.hpp>

extern "C" {
	int yyparse();
}

extern int yydebug;
using namespace std;

Program p;
extern "C" std::string baseDirectory;

int main (int argc, char* argv[]) {
	FILE* in;
	FILE* out;

#ifdef NDEBUG 
	cerr << "Setting debug\n";
	yyset_debug (0);
	//yydebug = 1;
#endif

	if (argc >= 2) {
		int x;
		 for (x = 1; x < argc; x++) {
			cerr << "processing " << argv[x] << endl;
			if (strncmp (argv[x], "-d", 2) == 0) {
				cerr << "Setting debug\n";
				//yyset_debug (1);
				yydebug = 1;
			} else {
				in = fopen (argv[x], "r");
				if (in == NULL) {
					cerr << "Could not use file " << argv[x] << " for input, using stdin" << endl;
				} else {
					cerr << "Using file " << argv[x] << " for input" << endl;
					baseDirectory.assign(dirname(argv[x]));
					baseDirectory.append("/");
					cerr << "basedir = " << baseDirectory <<endl;
					yyset_in (in);
					break;
				}
			}
		}
	}

	yyparse();


	if (in && in != stdin) {
		fclose (in);
	}
	if (out && out != stdout) {
		fclose (out);
	}

    return 0;
}

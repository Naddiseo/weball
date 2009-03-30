#include <iostream>
#include <string>
#include <cstring>
#include <lex.yy.h>
#include <defs.hpp>

extern "C" {
    int yyparse();
}

using namespace std;

int main (int argc, const char* argv[]) {
    FILE* in;
    FILE* out;

#if NDEBUG == 2
	cerr << "Setting debug\n";
    yyset_debug (1);
#endif

    if (argc >= 2) {
        int x;
        for (x = 1; x < argc; x++) {
			cerr << "processing " << argv[x] << endl;
            if (strncmp (argv[x], "-d2", 3) == 0) {
				cerr << "Setting debug\n";
                yyset_debug (1);
            } else {
                in = fopen (argv[x], "r");
                if (in == NULL) {
                    cerr << "Could not use file " << argv[x] << " for input, using stdin" << endl;
                } else {
                    cerr << "Using file " << argv[x] << " for input" << endl;
                    yyset_in (in);
					break;
                }

            }
        }
    }

    while (yyparse() == 0) {}

    removeRoles();

    if (in && in != stdin) {
        fclose (in);
    }
    if (out && out != stdout) {
        fclose (out);
    }

    return 0;
}

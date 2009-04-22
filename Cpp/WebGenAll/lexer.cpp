#include <lexer.hpp>
#include <cstdlib>
#include <stack>

string baseDirectory = "";

int debug  = 0;
int lineno = 0;
int charno = 0;
int look   = 0;
int peek   = 0;
bool bol   = false;

// the pointer to the current input file.
FILE* in = stdin;

typedef std::stack<FILE*> files_t;
// The input buffer list.
files_t buffer;

// sets the base directory for including files.
void yyset_baseDirectory(string bd) { baseDirectory = bd; }

// set the debug flag
void yyset_debug(int d = 0) { debug = d; } 

int yyget_lineno() { return lineno; }
int yyget_charno() { return charno; }

// Generic error function
void error (string err) {
	std::cerr << "Lexer error line [" << lineno << ":" << charno << "]: " << err << std::endl;
	exit(-1);
}

// Add a file stream to the stack
void pushBuffer(FILE* f = NULL) { buffer.push(f); }
// switch the the top of the stack, then pop it off
void popBuffer () { in = buffer.top(); buffer.pop(); }

// sets the input file.
void yyset_in(FILE* _i) {
	if (_i != NULL) {
		if (in != stdin) {
			pushBuffer(in);
		}
		in = _i;
	}
	else {
		error("Specified input is null");
	}
}

void includeFile(string path) {
	FILE* fp = fopen(path.c_str(), "r");
	if (!fp) {
		error("Could not include file: " + path);
	}
	yyset_in(fp);
}

void closeBuffer() {
	if (in != NULL && in != stdin) {
		fclose(in);
		if (buffer.size()) {
			popBuffer();
		}
	}
}

bool isLineEnd() {
	return (
		look == '\n' or                      // *nix
		(look == '\r' and peek == '\n') or  // windows
		(look == '\r')                     // mac
	);
}

void next() {
	look = peek;
	peek = fgetc(in);
	if (look == '\n') {
		lineno++;
		charno = 1;
		bol = true;
	} 
	else if (look == '\r') {
		if (peek == '\n') {
			look = peek;
			peek = fgetc(in);
		}
		lineno++;
		charno = 1;
		bol = true;
	}
	else {
		bol = false;
		charno++;
	}
}

void lex_init() {
	next();
	next();
}

void eatWhite() {
	while (look == ' ' or look == '\t') {
		next();
	}
}

int yylex() {
	if (look == EOF) {
		closeBuffer();
		return t_eof;
	}
	else if (look == '\t') {
		if (bol) {
			unsigned int tbol = 0;
			while (look == '\t') {
				next();
				tbol++;
			}
			eatWhite();
			if (bol) {
				// it was a blank line
				return yylex();
			}
			yylval.indent = tbol;
			return t_bol;
		}
		else {
			eatWhite();
			return yylex();
		}
	}
	else if (look == ' ') {
		eatWhite();
		return yylex();
	}
	else if (look == '#') {
		// skip to end of line
		next();
		while (!bol and look != EOF) {
			next();
		}
		return t_comment;
	}
	else {
		return look;
	}
	return t_eof;
}

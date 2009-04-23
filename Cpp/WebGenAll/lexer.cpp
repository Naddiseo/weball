#include <lexer.hpp>
#include <cstdlib>
#include <stack>


#define TOK(t, v) { tmap[t] = #t; keywords[v] = t; }

typedef std::map<int, string> STok;

STok tmap;

string baseDirectory = "";

int debug  = 0;
int lineno = 0;
int charno = 0;
int look   = 0;
int peek   = 0;
// the file starts at the beginning of a line!!
bool bol   = true;

typedef std::map<string, int> MToken;

// map of the keywords.
MToken keywords;

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
void popBuffer () { in = buffer.top(); bol = true; buffer.pop(); }

// sets the input file.
void yyset_in(FILE* _i) {
	if (_i != NULL) {
		if (in != stdin) {
			pushBuffer(in);
		}
		in = _i;
		// new file, so bol
		bol = true;
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
	if (debug) {
		std::cerr << "Using include " << path << std::endl;
	}
	yyset_in(fp);
}

void closeBuffer() {
	if (in != NULL && in != stdin) {
		fclose(in);
		in = NULL;
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

	//previous char was new line, therefor we're at the beginning of a line
	bol = (look == '\n');
	
	look = peek;
	peek = fgetc(in);
	
	switch (look) {
		case '\r':
			if (peek == '\n') {
				// windows line endings
				peek = fgetc(in);
			}
			// ignore the \r
			look = '\n';
			// fall through, because look == '\n' now
		case '\n':
			lineno++;
			charno = 1;
			break;
		default:
			charno++;
	}
}

void lex_init() {
	next();
	next();
	// it *is* the beginning.
	bol = true;
	TOK(t_attribute,  "t_attribute");
	TOK(t_bol,        "t_bol"      );
	TOK(t_bool,       "bool"       );
	TOK(t_class,      "class"      );
	TOK(t_config,     "config"     );
	TOK(t_dbfunction, "dbfunction" );
	TOK(t_eol,        "t_eol"      );
	TOK(t_eof,        "t_eof"      );
	TOK(t_ident,      "t_ident"    );
	TOK(t_index,      "index"      );
	TOK(t_int,        "int"        );
	TOK(t_intval,     "intval"     );
	TOK(t_pk,         "pk"         );
	TOK(t_return,     "return"     );
	TOK(t_string,     "string"     );
	TOK(t_stringval,  "stringval"  );
	TOK(t_typedef,    "typedef"    );
	TOK(t_uint,       "uint"       );
	TOK(t_uintval,    "uintval"    );
}

void eatWhite() {
	while (look == ' ' or look == '\t') {
		next();
	}
}

inline bool isAlpha() {
	return ((look >= 'a' and look <= 'z') or (look >= 'A' and look <= 'Z'));
}

inline bool isDigit(int c = look) {
	return (c >= '0' and c <= '9');
}

inline bool isAlNum() {
	return isDigit() or isAlpha();
}

PString getIdent() {
	PString ret = new string();
	if (isAlpha()) {
		ret->append(1, (char)look);
		next();
	}
	else {
		error("Expected ident");
	}
	
	while (isAlNum() or look == '_') {
		ret->append(1, (char)look);
		next();
	}	
	
	return addString(ret);
}

PString getStringVal(char end) {
	PString buf = new string;
	
	while (look) {
		next();
		if (look == end) {
			break;
		} 
		else if (look == '\n') {
			error("Strings cannot have newlines");
			break;
		}
		else if (look == '\\') {
			next();
			switch (look) {
				case '\\':
				case 't':
				case ' ':
				case '"':
				case '\'':
					buf->append(1, look);
				default:
					buf->append("\\");
					buf->append(1, look);
			}
		}
		else if (look == EOF || !look) {
			error("End of file reached with in string");
			break;
		}
		else {
			buf->append(1, look);
		}
	}
	return addString(buf);
}

unsigned int getUInt() {
	unsigned int ret = 0;
	
	while (isDigit()) {
		ret = ret * 10 + look - '0';
		next();
	}
	
	return ret;
}

int yylexwrap() {
top:
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
			if (look == '\n') {
				next();
				// it was a blank line
				//return yylex();
				goto top;
			}
			yylval.indent = tbol;
			return t_bol;
		}
		else {
			eatWhite();
			//return yylex();
			goto top;
		}
	}
	else if (look == ' ') {
		eatWhite();
		//return yylex();
		goto top;
	}
	else if (look == '#') {
		// skip to end of line
		next();
		while (look != '\n' and look != EOF) {
			next();
		}
		return t_comment;
	}
	else if (look == ':') {
		next();
		yylval.identval = getIdent();
		return t_attribute;
	}
	else if (isAlpha()) {
		yylval.identval = getIdent();
		if (int k = keywords[*(yylval.identval)]) {
			return k;
		}
		return t_ident;
	}
	else if (isDigit()) {
		yylval.uintval = getUInt();
		return t_uintval;
	}
	else if (look == '-') {
		if (isDigit(peek)) {
			next();
			yylval.intval = -getUInt();
			return t_intval;
		}
		return (int)'-';
	}
	else if (look == '\n') {
		if (bol) {
			// it's just a blank line, skip it
			next();
			goto top;
		}
		next();
		return t_eol;
	}
	else if (look == '"' or look == '\'') {
		yylval.stringval = getStringVal(look);
		return t_stringval;
	}
	else if (look == '(' or look == ')' or look == ',') {
		int ret = look;
		next();
		return ret;
	}
	else {
		std::cerr << "emitting: " << (char)look << std::endl;
	}
	closeBuffer();
	return t_eof;
}

int yylex() {
	int ret = yylexwrap();
	if (debug) {
		char c = (char)ret;
		string s;
		s.append(1,c);
		string tname = tmap.find(ret) != tmap.end() ? tmap[ret] : s;
		std::cerr << "got token: " << tname << std::endl;
	}
	return ret;
}

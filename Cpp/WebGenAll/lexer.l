%{
#include <config.h>
#include <iostream>
#include <parser.tab.h>
#include <cstring>

/* C stuff here */

extern "C" int yywrap();
extern "C" int yyget_lineno();
string baseDirectory;


static void yy_warn (yyconst char* msg ) {
	(void) fprintf( stderr, "Lexer Warning:(%d) %s\n", yyget_lineno(), msg );
}



char err_buf[100];

extern VPString strings_ptr;
// add a string pointer to the list.
inline PString addStr(PString p) { 
	strings_ptr.push_back(p); return p;
}

#define processEOF() { \
	yypop_buffer_state(); \
	\
	if (!YY_CURRENT_BUFFER) { \
		yyterminate(); \
		return t_eof; \
	} \
} \

%}
%option debug
%option outfile="lexer.c" header-file="lexer.h"

%x incl

%%

^\s {

	register char c = *yytext;
	bool isEmptyLine = true;
	unsigned int bol = 0;
	// if the line starts with a tab, it's a t_bol
	if (c == '\t') {
		// see how many we have.
		while (c == '\t') {
			bol++;
			c = yyinput();
		}
		// if there's whitespace, eat it
		if (c == ' ') {
			while (c && c == ' ') {
				c = yyinput();
			}
		}
		
		// end of file, and blank line.
		if (c == EOF) {
			processEOF();
		}
		// end of line, so discard
		else if (c == '\r' || c == '\n') {
			// do nothing
		}
		else {
			unput(c);
			isEmptyLine = false;
		}
	}
	
	if (!isEmptyLine) {
		yylval.indent = bol;
		return t_bol;
	}
}




 /*^\t+ {
	yylval.indent = yyleng;
	return t_bol;
}*/


\r|\r\n|\n {
	return t_eol;
}

#[^\r\n]* {
	yylval.comment = addStr(new string(yytext));
	return t_comment;
}

include[^(]*\(	{
	BEGIN(incl); 
}

class       { return t_class;      }
config      { return t_config;     }
typedef     { return t_typedef;    }
dbfunction  { return t_dbfunction; }
return      { return t_return;     }

index       { return t_index;     }
pk          { return t_pk;        }

int    { return t_int;    }
uint   { return t_uint;   }
string { return t_string; }
bool   { return t_bool;   }


[0-9]+ {
	yylval.uintval = atoi(yytext);
	return t_uintval;
}

-[0-9]+ {
	yylval.intval = atoi(yytext);
	return t_intval;
}

:[a-zA-Z][a-zA-Z0-9_]* {
	yylval.identval = addStr(new string(yytext));
	// remove the initial :
	yylval.identval->erase(0, 1);
	return t_attribute;
}

[a-zA-Z][a-zA-Z0-9_]* {
	yylval.identval = addStr(new string(yytext));
	return t_ident;
}

<incl>["'] {
	string path = "";
	
	register char c;
	char end = *yytext;
	while (c = yyinput()) {
		if (c == end) {
			break;
		} 
		else if (c == '\n') {
			yy_fatal_error("Include paths cannot have newlines");
			break;
		}
		else if (c == '\\') {
			c == yyinput();
			switch (c) {
				case '\\':
				case 't':
				case ' ':
				case '"':
				case '\'':
					path.append(1, c);
				default:
					path.append("\\");
					path.append(1, c);
			}
		}
		else if (c == EOF || !c) {
			yy_fatal_error("End of file reached with in include path");
			break;
		}
		else {
			path.append(1, c);
		}
	}
	
	if (c != end) {
		yy_fatal_error ("Didn't find end of string for include path");
	}
	
	bool expect_rparen = true;
	// Now eat to the end of line
	while (c = yyinput()) {
		if (c == EOF) {
			yy_fatal_error ("End of file reached while looking for t_rparen");
		}
		else if (c == ')') {
			expect_rparen = false;
		}
		else if (c == '\r') {
			c = yyinput();
			if (c != '\n') {
				unput(c);
			}
			break;
		}
		else if (c == '\n') {
			break;
		}
		else if (c == ' ' || c == '\t') {
			continue;
		}
		else {
			sprintf(err_buf, "Lexer: unexpected character '%c' on line %d", (char)c, yyget_lineno());
			yy_fatal_error (err_buf);
		}
	}
	
	if (expect_rparen) {
		sprintf(err_buf, "Lexer: expected rparen but was not found, on line %d", yyget_lineno());
		yy_fatal_error (err_buf);
	}
	
	const char* includePath = path.insert(0, baseDirectory).c_str();
	yyin = fopen(includePath, "r");
	
	if (!yyin) {
		sprintf(err_buf, "Lexer: Could not open file(%s) on line %d", includePath, yyget_lineno());
		yy_fatal_error(err_buf);
	}

#ifdef NDEBUG
	std::cout << "Including file (" << includePath << ")" << std::endl;
#endif

	yypush_buffer_state(
		yy_create_buffer(yyin, YY_BUF_SIZE)
	);
	
	BEGIN(INITIAL);
}

["'] {
	string* buf = addStr(new string);
	
	register char c;
	char end = *yytext;
	while (c = yyinput()) {
		if (c == end) {
			break;
		} 
		else if (c == '\n') {
			yy_fatal_error("Strings paths cannot have newlines");
			break;
		}
		else if (c == '\\') {
			c == yyinput();
			switch (c) {
				case '\\':
				case 't':
				case ' ':
				case '"':
				case '\'':
					buf->append(1, c);
				default:
					buf->append("\\");
					buf->append(1, c);
			}
		}
		else if (c == EOF || !c) {
			yy_fatal_error("End of file reached with in include path");
			break;
		}
		else {
			buf->append(1, c);
		}
	}
	
	yylval.stringval = buf;
	return t_stringval;
}



[,()] { return *yytext; }

[\t ]+ {/* discard white space */}

. { /* discard anything else, change to an error later! */
	yy_warn(yytext);
 }

<<EOF>> {
	yypop_buffer_state();
	
	if (!YY_CURRENT_BUFFER) {
		yyterminate();
		return t_eof;
	}
}



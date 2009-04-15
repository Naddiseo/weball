%{

#include <iostream>
#include <parser.tab.h>
#include <string>
#include <cstring>

/* C stuff here */

extern "C" int yywrap();
extern "C" int yyget_lineno();
extern std::string base_dir;
/*
static void yy_warn (yyconst char* msg ) {
	(void) fprintf( stderr, "Lexer Warning:(%d) %s\n", yyget_lineno(), msg );
}
*/


char err_buf[100];


%}
%option debug
%option outfile="lexer.c" header-file="lexer.h"

%x incl
%x config

%%

^\s+$ { /* do nothing for empty lines */ }

^\r|\r\n|\n { /* skip empty lines */ }

^\t+ {
	yylval.indent = yyleng;
	return t_bol;
}


\r|\r\n|\n {
	return t_eol;
}

#[^\r\n]* {
	yylval.comment = new std::string(yytext);
	return t_comment;
}

include[^(]*\(	{
	BEGIN(incl); 
}

config {
	return t_config;
}

typedef {
	return t_typedef;
}

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
	yylval.identval = new std::string(yytext);
	// remove the initial :
	yylval.identval->erase(0, 1);
	return t_attribute;
}

[a-zA-Z][a-zA-Z0-9_]* {
	yylval.identval = new std::string(yytext);
	return t_ident;
}

<incl>["'] {
	std::string path = "";
	
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
	
	const char* includePath = path.insert(0, base_dir).c_str();
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
	std::string* buf = new std::string;
	
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
<<EOF>> {
	yypop_buffer_state();
	
	if (!YY_CURRENT_BUFFER) {
		yyterminate();		
		return t_eof;
	}
}



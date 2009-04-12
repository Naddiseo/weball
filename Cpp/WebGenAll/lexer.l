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


%}
%option debug
%option outfile="lexer.c" header-file="lexer.h"

%x incl
%x config

%%

^\s+$ { /* do nothing for empty lines */ }

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

[a-zA-Z][a-zA-Z0-9_]* {
	yylval.identval = new std::string(yytext);
	return t_ident;
}

<incl>["'] {
	std::string path = "";
	
	register char c;
	char end = *yytext;
	while (true) {
		c = yyinput();
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
	
	const char* includePath = base_dir.append(path).c_str();
	yyin = fopen(includePath, "r");
	
	if (!yyin) {
		char buf[100];
		sprintf(buf, "Lexer: Could not open file(%s) on line %d", includePath, yyget_lineno());
		yy_fatal_error(buf);
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
	while ((c = yyinput()) != EOF) {
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
	return t_string;
}

\( { return t_lparen; }
\) { return t_rparen; }

<<EOF>> {
	yypop_buffer_state();
	
	if (!YY_CURRENT_BUFFER) {
		yyterminate();
	}
	return t_eof;
}



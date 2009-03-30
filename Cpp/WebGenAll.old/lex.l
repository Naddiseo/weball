%{

#include <iostream>
#include <grammar.tab.h>
#include <string>

/* C stuff here */

extern "C" int yywrap();
extern "C" int yyget_lineno();
/*
static void yy_warn (yyconst char* msg ) {
	(void) fprintf( stderr, "Lexer Warning:(%d) %s\n", yyget_lineno(), msg );
}
*/
int isWhite(char c) {
	return ((c == ' ') || (c == '\t') || (c == '\n') || (c == '\r'));
}

%}
%%

#[^\n\r]* { /* skip */ }

[\s\t ]	{ /* whitespace */ }

rx {
	/* Match a regex */
	char endC, c;
	std::string* buf = new std::string();

	while (isWhite(c = yyinput())) { }

	endC = c;
	buf->append(1, c);

	while (1) {
		c = yyinput();
		if (c == '\\') {
			c = yyinput();
		}
		else if (c == endC) {
			buf->append(1, c);
			break;
		}

		buf->append(1, c);

		if (c == EOF) {
			yy_fatal_error("Unterminated regex");
			break;
		}
	}

	yylval.rxval = buf;
	return t_rxval;
}

roles {return t_roles; }
class { return t_class; }
type { return t_type; }
as {return t_as; }

uint { return t_uint; }
int {return t_int; }
string {return t_string; }
bool {return t_bool; }

[a-zA-Z][a-zA-Z0-9_-]* {
	yylval.identval = new std::string(yytext);
	return t_ident;
}

-[0-9]+ {
	yylval.intval = atoi(yytext);
	return t_intval;
}

[0-9]+ {
	yylval.uintval = atoi(yytext);
	return t_uintval;
}

[=;:,{}\[\]-] { return *yytext; }

\r\n|\r|\n { /* ignore */ }

<<EOF>> { return t_eof; }

.	{
	char buf[50];
	sprintf(buf, "Lexer: Unexpected char(%s) on line %d", yytext, yyget_lineno());
	yy_fatal_error(buf);
}
%%

%{

#include <stdio.h>
#include <grammar.tab.h>
#include <stdlib.h>

/* C stuff here */

extern int yywrap();
extern unsigned int cline;

static void yy_warn (yyconst char* msg ) {	//modified yy_fatal_error
	(void) fprintf( stderr, "Lexer Warning:(%d) %s\n", cline, msg );
}

int isWhite(char c) {
	return ((c == ' ') || (c == '\t') || (c == '\n') || (c == '\r'));
}

%}
%%

#[^\n\r]* { cline++; }

[\s\t ]	{ /* whitespace */ }

rx {
	/* Match a regex */
	unsigned i = 0, top = 10;
	char endC, c;
	char* buf = (char*)malloc(10 * sizeof(char));
	
	if (buf == NULL) {	
		yy_fatal_error("Could not allocated memory");
	}

	while (isWhite(c = input())) { }
	
	endC = c;
	buf[i++] = c;
	
	while (1) {
		c = input();
		if (c == '\\') {
			c = input();
			buf[i++] = c;
		}
		else if (c == endC) {
			buf[i++] = c;
			break;		
		}
		else {
			buf[i++] = c;
		}
		if (c == EOF) {
			yy_fatal_error("Unterminated regex");
			break;
		}		
		if (i == top - 1) {
			top += 10;
			buf = (char*)realloc(buf, 10 * sizeof(char));
			if (buf == NULL) {	
				yy_fatal_error("Could not allocated memory");
			}
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
	yylval.identval = strdup(yytext);
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

\r\n|\r|\n { cline++; }

<<EOF>> { return t_eof; }

.	{
	char buf[50];
	sprintf(buf, "Lexer: Unexpected char(%s) on line %d", yytext, cline);
	yy_fatal_error(buf);
}
%%

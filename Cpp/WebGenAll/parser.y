%{
#define YYERROR_VERBOSE
#if !defined(YYDEBUG) && defined(NDEBUG)
#	define YYDEBUG
#endif
#include <lexer.h>
#include <string>
#include <map>
#include <iostream>
#include <typeinfo>
#include <Config.hpp>
//#include <defs.hpp>
extern "C" {
    void yyerror (const char *);
    int yyparse();
    int yywrap();

}

extern int yylineno;

void checkIndent (int x, int y) {
	if (x != y) {
		yyerror("Bad indent");
	}
}
%}

%union {
    std::string* identval;
    std::string* stringval;
    std::string* rxval;
    std::string* comment;
    unsigned int uintval;
    int intval;
    int indent;
}

%token t_roles t_class t_type t_as t_config
%token t_lparen t_rparen
%token t_int t_uint t_string t_ident t_bool t_intval t_uintval t_rxval t_stringval
%token t_eof t_eol t_comment t_bol

%type <rxval> t_rxval
%type <intval> t_intval
%type <uintval> t_uintval
%type <identval> t_ident

%destructor { delete ($$); } t_ident t_rxval


%%

start
	: /*empty */
	| t_eol { /* do nothing for an empty line */YYACCEPT; }
	| t_eof { YYABORT }
	| config_section
	;

config_section 
	: t_config config_parts
	;

config_parts
	: config_parts t_bol { checkIndent(1, $<indent>2); } t_ident t_lparen t_string t_rparen t_eol { addConfig(*$<identval>4, *$<identval>6); }
	| t_eol
	| 
	;


%%

void
yyerror (const char *str) {
	extern int yyget_lineno();
    fprintf (stderr, "Error on line %d: %s\n", yylineno, str);
}

int
yywrap() {
    return 1;
}

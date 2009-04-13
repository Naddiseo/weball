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
    bool boolval;
}

%token t_roles t_class t_typedef t_attribute t_config
%token t_lparen t_rparen
%token t_ident
%token t_int t_uint t_string t_bool
%token t_intval t_uintval t_rxval t_stringval t_boolval
%token t_eof t_eol t_comment t_bol

%type <rxval> t_rxval
%type <intval> t_intval
%type <uintval> t_uintval
%type <identval> t_ident t_attribute
%type <comment> t_comment
%type <stringval> t_stringval
%type <boolval> t_boolval

%destructor { delete ($$); } t_ident t_attribute t_rxval t_stringval t_comment


%%

start
	: /*empty */
	| t_eol { /* do nothing for an empty line */YYACCEPT; }
	| t_eof { YYABORT }
	| config_section start
	| t_typedef typedef_line start
	;

config_section 
	: t_config t_eol config_parts
	;

config_parts
	: config_parts t_bol { checkIndent(1, $<indent>2); } t_ident t_lparen t_stringval t_rparen t_eol { addConfig(*$<identval>4, *$<stringval>6); }
	| 
	;

typedef_line
	: t_bool t_ident member_attributes {}
	| t_int t_ident member_attributes {}
	| t_uint t_ident member_attributes {}
	| t_string t_ident member_attributes {}
	| t_ident t_ident member_attributes {}
	| 
	;

member_attributes
	: member_attributes t_attribute
	| member_attributes t_attribute t_lparen 
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

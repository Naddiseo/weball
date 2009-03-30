%{
#define YYERROR_VERBOSE
#if !defined(YYDEBUG) && defined(NDEBUG)
#	define YYDEBUG
#endif
#include <lex.yy.h>
#include <string>
#include <map>
#include <defs.hpp>
extern "C" {
    void yyerror (const char *);
    int yyparse();
    int yywrap();

}


extern int yylineno;
%}

%union {
    std::string* identval;
    std::string* rxval;
    unsigned int uintval;
    int intval;
}

%token t_roles t_class t_type t_as
%token t_int t_uint t_string t_ident t_bool t_intval t_uintval t_rxval t_stringval
%token t_eof

%type <rxval> t_rxval
%type <intval> t_intval
%type <uintval> t_uintval
%type <identval> t_ident

%destructor { delete ($$); } t_ident t_rxval

%left ','
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc X_UMINUS
%left '('
%left '['

%%

start
	: /*empty */
	| t_eof { YYABORT }
	| start expression { YYACCEPT }
	;

expression
	: role
	| class
	| type
    ;

role
	: t_roles '{' roles_list '}'
	;

class
    : t_class t_ident '{' class_list '}' {}
	;

type
	: t_type t_ident t_as type_properties
	;

roles_list
	: /* empty */
	| roles_list roles_list_entry
	;

roles_list_entry
	: vtype_num t_ident ',' { addRole($<intval>1, $<identval>2); }
	;

class_list
	: /* empty */
	| class_list class_list_entry
	;

class_list_entry
	: vtype t_ident class_list_vtype_properties ','
	| t_ident t_ident class_list_vtype_properties ','
	;

class_list_vtype_properties
	: vtype_range vtype_fn vtype_default
	;

type_properties
	: vtype vtype_range vtype_fn ';'
	;

vtype
	: t_uint
	| t_int
	| t_string
	| t_bool
	;

vtype_range
	: '[' vtype_num ':' vtype_num ']'
	| '[' vtype_num ']'
	| /* or nothing */
	;

vtype_fn
	: /* empty */
	| t_ident params
	;

vtype_default
	:/*empty */
	| '=' vtype_var
	;

params
	: /* none */
	| '(' /*none*/ ')'
	| vtype_var
	| '(' vtype_list ')'
	;

vtype_list
	: vtype_list ',' vtype_var
	| vtype_var
	;

vtype_var
	: vtype_num
	| t_rxval
	| t_stringval
	;

vtype_num
	: t_intval
	| t_uintval
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

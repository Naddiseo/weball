%{
#define YYERROR_VERBOSE 1
#if !defined(YYDEBUG) && defined(NDEBUG)
#	define YYDEBUG 1
#endif
#include <config.h> 
//#include <lexer.h>
#include <lexer.hpp>
#include <Program.hpp>

extern Program p;

extern "C" {
	void yyerror (const char *);
	int yyparse();
	int yywrap();
}

int yyget_lineno();

void checkIndent (int x, int y) {
	if (x != y) {
		yyerror("Bad indent");
		exit(-1);
	}
}

%}

%union {
	string* identval;
	string* stringval;
//	string* rxval;
	string* comment;
	unsigned int uintval;
	int intval;
	int indent;
	bool boolval;
	
	IVal* iv;
	VIVal* viv;
	DBFunction* dbfn;
}

%token t_typedef t_attribute t_config t_class t_dbfunction t_return
%token t_index t_pk
%token t_ident
%token t_comment
%token t_int t_uint t_string t_bool
%token t_intval t_uintval /*t_rxval*/ t_stringval t_boolval
%token t_eof t_eol t_bol

//%type <rxval> t_rxval
%type <intval> t_intval
%type <uintval> t_uintval
%type <identval> t_ident t_attribute
%type <comment> t_comment
%type <stringval> t_stringval
%type <boolval> t_boolval
%type <indent> t_bol

%type <iv> ival 
%type <dbfn> dbfunction
%type <viv> ident_list_container

%left ','

%%

start
	: /* empty */
	| t_eol { YYACCEPT; }
	| t_eof { YYABORT;  }
	| lines t_eof
	;

lines
	: line
	| lines line
	;

line
	: config_section
	| t_typedef typedef_line t_eol
	| t_comment
	| class_block
	;


config_section 
	: t_config t_eol config_parts
	;

config_parts
	: config_parts t_bol t_ident '(' t_stringval ')' t_eol { 
		checkIndent(1, $2);
		p.addConfig(*$3, *$5); 
	}
	| /* Empty config.. */
	;

typedef_line
	: t_bool t_ident   { p.newType(*$2, true); } member_attributes {
		p.copyType(string("bool"), *$2);
	}
	| t_int t_ident    { p.newType(*$2, true); } member_attributes {
		p.copyType(string("int"), *$2);
	}
	| t_uint t_ident   { p.newType(*$2, true); } member_attributes {
		p.copyType(string("uint"), *$2);
	}
	| t_string t_ident { p.newType(*$2, true); } member_attributes {
		p.copyType(string("string"), *$2);
	}
	| t_ident t_ident  { p.newType(*$2, true); } member_attributes {
		p.copyType(*$1, *$2);
	}
	;
	
member_attributes
	: /* no attributes */
	| member_attributes t_attribute { p.addAttribute(*$2, true); } attribute_values {
		//SETATTR(*$2);
	}
	;

attribute_values
	: /* none */
	| '(' value_list ')'
	| '(' ')'
	;

value_list	
	: type_val               
	| value_list ',' type_val
	;

type_val
	: t_boolval   { p.addTypeValue(new TypeValue ( $1)); }
	| t_intval    { p.addTypeValue(new TypeValue ( $1)); }
	| t_uintval   { p.addTypeValue(new TypeValue ( $1)); }
	| t_stringval { p.addTypeValue(new TypeValue (*$1)); }
	;

class_block
	: t_class t_ident { p.newClass(*$2, true); } t_eol class_members
	;

class_members
	: class_members t_bol class_member t_eol
	| t_bol { checkIndent(1, $1); } class_member t_eol
	;

class_member
	: t_bool   t_ident { p.addClassMember(string("bool"  ), *$2); } member_attributes
	| t_uint   t_ident { p.addClassMember(string("uint"  ), *$2); } member_attributes
	| t_int    t_ident { p.addClassMember(string("int"   ),  *$2); } member_attributes
	| t_string t_ident { p.addClassMember(string("string"), *$2); } member_attributes
	| t_ident  t_ident { p.addClassMember(*$1,              *$2); } member_attributes
	| t_pk    { p.addPK();    } ident_list_container { p.endPK();    }
	| t_index { p.addIndex(); } ident_list_container { p.endIndex(); }
	| dbfunction { $$->push }
	;

ident_list_container
	: '(' ident_list ')'  { $$ = $1; }
	| '('')'              { $$ = new VIVal(); }
	;

ident_list
	: ident_list ',' ival { $$ = $1->push_back($3);}
	| ival                { $$->push_back($1);     }
	;

ival
	: t_ident '.' t_ident { $$ = new IVal(*$1, *$3); }
	| t_ident             { $$ = new IVal("", *$1) ; }

dbfunction
	: t_dbfunction t_ident ident_list_container t_eol dbfunction_members {
		$$ = new DBFunction(*$2, $3, $5);
	}
	;

dbfunction_members
	: dbfunction_members t_bol dbfunction_member t_eol
	| t_bol dbfunction_member t_eol
	;

dbfunction_member
	: t_return ident_list_container
	;

%%

void
yyerror (const char *str) {
	fprintf (stderr, "Parser Error on line %d: %s\n", yyget_lineno(), str);
}

int
yywrap() {
	return 1;
}

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
#include <Types.hpp>
#include <Attributes.hpp>
#include <TypeValue.hpp>

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

TypeValueList_t* currentValueList;
TypeValue* currentTV;
Type* currentType;
attributeMap_t* currentAttributes;


#define NEWTYPE(name) {currentType = new Type(name); }
#define NEWATTRMAP { currentAttributes = new attributeMap_t(); }
#define NEWVLIST { currentValueList = new TypeValueList_t(); }

#define SETATTR(name, to) { \
	if (currentAttributes->find(name) != currentAttributes->end()) {} \
	if (to) { \
		(*currentAttributes)[name] = to; \
	} else { \
		(*currentAttributes)[name] = new TypeValueList_t; \
	} \
}

#define ADDVAL(tv) { currentValueList->push_back(tv); }

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
%type <indent> t_bol
%type <TypeValue*> type_val

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
	: config_parts t_bol t_ident t_lparen t_stringval t_rparen t_eol { 
		checkIndent(1, $2);
		addConfig(*$3, *$5); 
	}
	| 
	;

typedef_line
	: t_bool t_ident { NEWTYPE(*$2); NEWATTRMAP; } member_attributes {		
		copyType("bool", *$2);
		currentType->copyAttributes(currentAttributes);
				
	}
	| t_int t_ident { NEWTYPE(*$2); NEWATTRMAP; }  member_attributes {
		copyType("int", currentType);
		currentType->copyAttributes(currentAttributes);
	}
	| t_uint t_ident { NEWTYPE(*$2); NEWATTRMAP; }  member_attributes {
		copyType("uint", currentType);
		currentType->copyAttributes(currentAttributes);
	}
	| t_string t_ident { NEWTYPE(*$2); NEWATTRMAP; }  member_attributes {
		copyType("string", currentType);
		currentType->copyAttributes(currentAttributes);
	}
	| t_ident t_ident { NEWTYPE(*$2); NEWATTRMAP; } member_attributes {
		copyType(*$1, currentType);
		currentType->copyAttributes(currentAttributes);
	}
	;

member_attributes
	: member_attributes t_attribute {
		SETATTR(*$2, NULL);
	}
	| t_attribute t_lparen {NEWVLIST;} value_list t_rparen {
		SETATTR(*$1, currentValueList);
	}
	;

value_list
	: value_list ',' type_val { ADDVAL(currentTV); }
	| type_val { ADDVAL(currentTV); }
	;

type_val
	: t_boolval   { currentTV = new TypeValue ($1); }
	| t_intval    { currentTV= new TypeValue ($1); }
	| t_uintval   { currentTV = new TypeValue ($1); }
	| t_stringval { currentTV = new TypeValue ($1); }
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

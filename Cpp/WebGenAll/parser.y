%{
#define YYERROR_VERBOSE 1
#if !defined(YYDEBUG) && defined(NDEBUG)
#	define YYDEBUG
#endif
#define YYDEBUG 1
#include <lexer.h>
#include <string>
#include <map>
#include <iostream>
#include <typeinfo>
#include <Config.hpp>
#include <Types.hpp>
#include <Attributes.hpp>
#include <TypeValue.hpp>
#include <cstdlib>

extern "C" {
	void yyerror (const char *);
	int yyparse();
	int yywrap();
}


extern int yylineno;

void checkIndent (int x, int y) {
	if (x != y) {
		yyerror("Bad indent");
		exit(-1);
	}
}

TypeValueList_t* currentValueList;
TypeValue* currentTV;
Type* currentType;
attributeMap_t* currentAttributes;


inline void NEWTYPE(std::string name) {
	std::cerr << "**Creating type " << name << std::endl;
	currentAttributes = new attributeMap_t();
	currentType = newType(name, currentAttributes);
}
inline void NEWVLIST() {
	currentValueList = new TypeValueList_t();
}
inline void SETATTR(std::string name) { 
	if (currentAttributes->find(name) != currentAttributes->end()) {
		yyerror("Attribute already exists");
	} 
	(*currentAttributes)[name] = currentValueList; 
}

inline void ADDVAL(TypeValue* tv) { currentValueList->push_back(tv); }


%}

//%debug

%union {
	std::string* identval;
	std::string* stringval;
//	std::string* rxval;
	std::string* comment;
	unsigned int uintval;
	int intval;
	int indent;
	bool boolval;
}

%token t_typedef t_attribute t_config t_class
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
%type <TypeValue*> type_val

%destructor { delete ($$); } t_ident t_attribute t_stringval t_comment


%left ','

%%

start
	: /*empty */
	| t_eol { /* do nothing for an empty line */YYACCEPT; }
	| t_eof { YYABORT }
	| lines
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
		addConfig(*$3, *$5); 
	}
	| 
	;

typedef_line
	: t_bool t_ident { NEWTYPE(*$2); } member_attributes {
		copyType(std::string("bool"), *$2);
		currentType->copyAttributes(currentAttributes);
				
	}
	| t_int t_ident { NEWTYPE(*$2);  }  member_attributes {
		copyType(std::string("int"), currentType);
		currentType->copyAttributes(currentAttributes);
	}
	| t_uint t_ident { NEWTYPE(*$2); }  member_attributes {
		copyType(std::string("uint"), currentType);
		currentType->copyAttributes(currentAttributes);
	}
	| t_string t_ident { NEWTYPE(*$2); }  member_attributes {
		copyType(std::string("string"), currentType);
		currentType->copyAttributes(currentAttributes);
	}
	| t_ident t_ident { NEWTYPE(*$2); } member_attributes {
		copyType(*$1, currentType);
		currentType->copyAttributes(currentAttributes);
	}
	;

member_attributes
	: /* no attributes */
	| member_attributes t_attribute { NEWVLIST(); } attribute_values {
		SETATTR(*$2);
	}
	;

attribute_values
	: /* none */
	| '(' value_list ')'
	| '(' ')'
	;

value_list	
	: type_val { ADDVAL(currentTV); }
	| value_list ',' type_val { ADDVAL(currentTV); }
	;

type_val
	: t_boolval   { currentTV = new TypeValue ($1);  }
	| t_intval    { currentTV = new TypeValue ($1);  }
	| t_uintval   { currentTV = new TypeValue ($1);  }
	| t_stringval { currentTV = new TypeValue (*$1); }
	;
	
class_block
	: t_class t_ident t_eol class_members
	;

class_members
	: class_members t_bol class_member t_eol
	| t_bol class_member t_eol
	;

class_member
	: t_bool t_ident member_attributes
	| t_uint t_ident member_attributes
	| t_int t_ident member_attributes
	| t_string t_ident member_attributes
	| t_ident t_ident member_attributes
	;

%%


void
yyerror (const char *str) {
	fprintf (stderr, "Praser Error on line %d: %s\n", yylineno, str);
}

int
yywrap() {
	return 1;
}


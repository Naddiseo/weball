#include <error.hpp>
#include <iostream>
#include <lexer.hpp>

void parserError(string msg, const char* file, int line) {
	std::cerr << "Parser Error [" << yyget_lineno() << ":" << yyget_charno() << "]  : " << msg << " reported from [" << file << ':' << line << "]" << std::endl;
	exit(-1);
}

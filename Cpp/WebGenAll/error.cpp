#include <error.hpp>
#include <iostream>

void parserError(string msg, const char* file, int line) {
	std::cerr << "Parser Error [" << file << ':' << line << "] : " << msg << std::endl;
	exit(-1);
}

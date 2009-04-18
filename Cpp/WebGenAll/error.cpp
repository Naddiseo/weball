#include <error.hpp>
#include <iostream>

void parserError(string msg, int line) {
	std::cerr << "Parser Error [" << line << "] : " << msg << std::endl;
	exit(-1);
}

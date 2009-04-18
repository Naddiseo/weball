#include <error.hpp>
#include <iostream>

void parserError(std::string msg, int line) {
	std::cerr << "Parser Error [" << line << "] : " << msg << std::endl;
	exit(-1);
}

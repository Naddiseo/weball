#include <config.hpp>
#include <iostream>
void lexerError(string error, int inputLine, int inputChar, int line) {
	std::cerr << "Lexer Error [" << inputLine << ":" << inputChar << "] : " << error << "reported from [Lexer.cpp:" << line << "]" << std::endl;
	exit(-1);
}

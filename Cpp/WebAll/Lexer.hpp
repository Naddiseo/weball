#ifndef LEXER_HPP_INCLUDED
#define LEXER_HPP_INCLUDED
#include <config.hpp>
#include <fstream>

class Lexer {
public:
	Lexer(string _input);
	~Lexer();
private:
	string basePath;
	std::ifstream input;
	int lineno;
	int charno;

	char look;
	bool bol;

	void next();

	void eatWhite();
	bool isAlpha();
	bool isDigit();
	bool isAlnum();

};

#endif // LEXER_HPP_INCLUDED

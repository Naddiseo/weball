#include <Lexer.hpp>
#include <iostream>

Lexer::Lexer(string _input) {
	input.open(_input.c_str(), std::ifstream::in);
	lineno = 0;
	charno = 1;
	bol = true;
	if (input.bad()) {
		ldie("Could not open input file");
	}
}

Lexer::~Lexer() {
	if (input.is_open()) {
		input.close();
	}

}

void
Lexer::next() {

	bol = (look = '\n');
	look = input.get();
	if (!input.good()) {
		look = EOF;
	}
	else {
		switch (look) {
			case '\r':
				if ('\n' == input.peek()) {
					input.ignore();
				}
				look = '\n';
			case '\n':
				lineno++;
				charno = 1;
				break;
			default:
				charno++;
		}
	}
}

void
Lexer::eatWhite() {
	while (look == ' ' or look == '\t') {
		next();
	}
}

bool isAlpha() {
	return ((look >= 'a' and look <= 'z') or (look >= 'A' and look <= 'Z'));
}

bool isDigit() {
	return (c >= '0' and c <= '9');
}

bool isAlnum() {
	return isDigit() or isAlpha();
}

#ifndef CONFIG_HPP_INCLUDED
#define CONFIG_HPP_INCLUDED
#include <string>
#include <cstdlib>

#include <boost/foreach.hpp>
#define foreach BOOST_FOREACH

typedef std::string string;

class Lexer;
void lexerError(string error, int inputLine, int inputChar, int line);

#define ldie(msg) lexerError(msg, this->lineno, this->charno,  __LINE__)
#endif // CONFIG_HPP_INCLUDED

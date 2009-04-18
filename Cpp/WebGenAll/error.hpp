#ifndef __ERROR_HPP__
#define __ERROR_HPP__
#include <config.h>
#include <cstdlib>

void parserError(string, const char* file, int line);

#define pdie(msg) parserError(msg, __FILE__, __LINE__)

#endif

#ifndef __ERROR_HPP__
#define __ERROR_HPP__
#include <config.h>
#include <cstdlib>

void parserError(string, int line);

#define pdie(msg) parserError(#msg, __LINE__)

#endif

#ifndef __LEXER_HPP__
#define __LEXER_HPP__
#include <config.h>
#include <parser.tab.h>
#include <cstdio>

void lex_init();

int yylex();

void yyset_debug(int);
void yyset_in(FILE*);
void yyset_baseDirectory(string bd);

int yyget_lineno();
int yyget_charno();
#endif

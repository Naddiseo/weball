#!/bin/bash

flex --header-file=lex.yy.h lex.l
bison -vtd grammar.y

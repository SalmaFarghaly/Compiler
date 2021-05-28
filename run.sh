#!/bin/sh
bison prog.y -d -t --debug --verbose 

flex -d lex.l

gcc -DYYDEBUG=1 prog.tab.c lex.yy.c

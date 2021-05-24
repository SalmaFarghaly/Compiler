bison --yacc prog.y -d --debug --verbose
flex lex.l
gcc y.tab.c lex.yy.c
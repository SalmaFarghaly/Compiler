flex lex.l
bison --yacc prog.y -d
gcc y.tab.c lex.yy.c
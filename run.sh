bison prog.y -d --debug --verbose
flex lex.l
gcc -DYYDEBUG=1 prog.tab.c lex.yy.c
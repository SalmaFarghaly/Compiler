%{
    #include"prog.tab.h"
	#include<stdio.h>
	#include<stdlib.h>
	#include<malloc.h>
	#include<string.h>
    extern char yyval;
%}

%
alpha [a-zA-Z]
digit [0-9]
str \"[^"\n]*\"
character \'[^'\n]\'
%%
"-"   return SUB;
"+"   return ADD;
"*"   return MUL;
"/"   return DIV;
"%"   return REM;
">="  return GE;
"<="  return LE;
"=="  return EQ;
"<"   return L;
">"   return G;
"!="  return NEQ;
"="   return ASSIGN;
"&&"  return AND;
"||"  return OR;
"++"  return INC;
"--"  return DEC;
"^"   return XOR;
"char"      return CHAR;
"int"       return INT;
"float"     return FLOAT;
"string"    return STRING; 
"void"      return VOID;
"return"    return RETURN;
"double"    return DOUBLE; 
";"     return SEMICOLON;
","     return COMMA;
"("     return OP;
")"     return CP;
"{"     return OB;
"}"     return CB;

{alpha}({alpha}|{digit})* {return IDENTIFIER;}
{digit}+                  {return NUM;}
[0-9]+\.[0-9]+            {return REAL;}
{str}                     {return EXPSTR;}
{character}               {return EXPCHAR;}


[ \t] ;
[\n] ;
. ;

%%

int yywrap(void) {
    return 1;
}
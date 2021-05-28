%{
    #include"prog.tab.h"
	#include<stdio.h>
	#include<stdlib.h>
	#include<malloc.h>
	#include<string.h>
    extern char yyval;
%}
%option yylineno

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
"false" { printf("false\n");return FALSE;}
"true" {printf("true\n");return TRUE;}
"<"   return L;
">"   return G;
"!="  return NEQ;
"="   return ASSIGN;
"&&"  return AND;
"||"  return OR;
"++"  return INC;
"--"  return DEC;
"^"   return XOR;
"|"   return BitwiseOR;
"&"   return BitwiseAnd;
"char"      return CHAR;
"int"       return INT;
"float"     return FLOAT;
"string"    return STRING; 
"void"      return VOID;
"return"    return RETURN;
"double"    return DOUBLE; 
"bool"      return BOOL;
";"     return SEMICOLON;
":"		return COLON;
","     return COMMA;
"("     return OP;
")"     return CP;
"{"     return OB;
"}"     return CB;
"const"	return CONST;
"if"	return IF;
"then"	return THEN;
"else" return ELSE;
"while" return WHILE;
"do" return DO;
"until" return UNTIL;
"for" return FOR;
"switch" return SWITCH;
"case" return CASE;
"default" return DEFAULT;


{alpha}({alpha}|{digit})* { strcpy(yylval.ourinfo.name, (char*)yytext); return IDENTIFIER; }
{digit}+                  {return NUM;}
[0-9]+\.[0-9]+            {return DECIMAL;}
{str}                     {printf("stringg\n");return EXPSTR;}
{character}               {return EXPCHAR;}


[ \t] ;
[\n] {++yylineno;}
. ;

%%

int yywrap(void) {
    return 1;
}
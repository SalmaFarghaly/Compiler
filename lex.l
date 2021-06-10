%{

	#include "utilies.h"
    #include"prog.tab.h"
	#include<stdio.h>
	#include <errno.h>
	#include<stdlib.h>
	#include<malloc.h>
	#include<string.h>
	#define YYERROR_VERBOSE 1

    extern char yyval;
	static int next_column = 1;
    int column = 1;

    extern int yylex();

    extern char* yytext;

    


%}

%option nounput yylineno


alpha [a-zA-Z]
digit [0-9]
str \"[^"\n]*\"
character \'[^'\n]\'
comment_str \/\/[^\n]*
%%
"-"   {strcpy(yylval.ourinfo.name, (char*)yytext);return SUB;}
"+"   {strcpy(yylval.ourinfo.name, (char*)yytext);return ADD;}
"*"   return MUL;
"/"   return DIV;
"%"   return REM;
">="  {strcpy(yylval.ourinfo.name, (char*)yytext);return GreaterThan_Or_Equal;}
"<="  {strcpy(yylval.ourinfo.name, (char*)yytext);return LessThan_OR_Equal;}
"=="  {strcpy(yylval.ourinfo.name, (char*)yytext);return Equal;}
"false" { printf("false\n");return FALSE;}
"true" {printf("true\n");return TRUE;}
"<"   {strcpy(yylval.ourinfo.name, (char*)yytext);return LessThan;}
">"   {strcpy(yylval.ourinfo.name, (char*)yytext);return GreaterThan;}
"!="  {strcpy(yylval.ourinfo.name, (char*)yytext);return NotEqual;}
"="   {return ASSIGN;}
"&&"  return AND;
"||"  return OR;
"++"  return INC;
"--"  return DEC;
"^"   {strcpy(yylval.ourinfo.name, (char*)yytext);return XOR;}
"|"   {strcpy(yylval.ourinfo.name, (char*)yytext);return BitwiseOR;}
"&"   {strcpy(yylval.ourinfo.name, (char*)yytext);return BitwiseAnd;}
"!"   return NOT;
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
"("     return OPEN_Parentheses ;
")"     return CLOSED_Parentheses ;
"{"     return OPEN_Brackets;
"}"     return CLOSED_Brackets;
"//"		return DBL_FORWARD_SLASH;
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
"break" return BREAK;



{alpha}({alpha}|{digit})* { strcpy(yylval.ourinfo.name, (char*)yytext); yylval.ourinfo.variable=(char)yytext[0];return IDENTIFIER; }
{digit}+                  {strcpy(yylval.ourinfo.name, (char*)yytext);return NUM;}
[0-9]+\.[0-9]+            {strcpy(yylval.ourinfo.name, (char*)yytext);return DECIMAL;}
{str}                     {strcpy(yylval.ourinfo.name, (char*)yytext);return EXPSTR;}
{character}               {strcpy(yylval.ourinfo.name, (char*)yytext);return EXPCHAR;}
{comment_str}			{printf("Found a Single Line Comment\n");}

[ \t] ;
[\n] ;
.					printf("unexpected character\n");


%%

int yywrap(void) {
    return 1;
}
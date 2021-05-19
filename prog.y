
  
%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex();
%}
%union {
  struct info{ 
		char* name;
        char* value;
		int quadvalue;
		char * quad;
	    char  variable;
		char * string;    
        int  type;
    }ourinfo;
}  

%token  <ourinfo>IDENTIFIER 
%token  <ourinfo> NUM
%token  <ourinfo> REAL 
%token  <ourinfo> EXPCHAR
%token  <ourinfo> EXPSTR 
%token  CHAR INT FLOAT DOUBLE STRING VOID RETURN 
%token  EQ LE GE AND OR XOR ASSIGN L G NEQ
%token  ADD SUB MUL DIV INC DEC REM
%token SEMICOLON COMMA
%token  OP CP OB CB



%%




number
	: NUM	{$<ourinfo>$.type = 2 ;  strcpy($<ourinfo>$.value,$<ourinfo>1.value); }
	| REAL	{$<ourinfo>$.type = 3 ;  strcpy($<ourinfo>$.value,$<ourinfo>1.value); }
	;
	
string
	:EXPSTR  {$<ourinfo>$.type = 4 ;  strcpy($<ourinfo>$.value,$<ourinfo>1.value); }
	|EXPCHAR {$<ourinfo>$.type = 1 ;  strcpy($<ourinfo>$.value,$<ourinfo>1.value); }
	;
type 
	: INT   {  $<ourinfo>1.type = 2 ; $<ourinfo>$=$<ourinfo>1; typeno=2}
	| CHAR  {  $<ourinfo>1.type = 1 ; $<ourinfo>$=$<ourinfo>1; typeno=1}
	| FLOAT {  $<ourinfo>1.type = 3 ; $<ourinfo>$=$<ourinfo>1; typeno=3}
	| VOID  {  $<ourinfo>1.type = 0 ; $<ourinfo>$=$<ourinfo>1; typeno=0}
	|STRING {  $<ourinfo>1.type = 4 ; $<ourinfo>$=$<ourinfo>1; typeno=4} 
	;

variable
	: IDENTIFIER {  $<ourinfo>$.name=declarationcheck($<ourinfo>$.name,typeno); $<ourinfo>$.type=typeno;  printf("%d\n",$<ourinfo>$.type); }
	;
argument 
	: type variable
	;
argumentlist
	: argument
	| argument COMMA argumentlist
	| {;}
	;


operation
	: ADD {$<ourinfo>$.value='+';}
	| SUB {$<ourinfo>$.value='-';}
	| MUL {$<ourinfo>$.value='*';}
	| DIV {$<ourinfo>$.value='/';}
	;



%%


extern FILE *yyin;

void yyerror (char const *s) {
	fprintf (stderr, "%s\n", s);
}



int main()
{
	yyparse();
	return 0;
}





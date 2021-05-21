
  
%{
	void yyerror (char const *s);
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex();
	int typeno;
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

%start line
%token  <ourinfo>IDENTIFIER 
%token  <ourinfo> NUM
%token  <ourinfo> DECIMAL 
%token  <ourinfo> EXPCHAR
%token  <ourinfo> EXPSTR 
%token  CHAR INT FLOAT DOUBLE STRING VOID RETURN BOOL
%token  EQ LE GE AND OR XOR ASSIGN L G NEQ
%token  ADD SUB MUL DIV INC DEC REM
%token SEMICOLON COMMA IF THEN CONST
%token  OP CP OB CB
%token FALSE TRUE



%%



line
	: statements SEMICOLON
	| statements SEMICOLON line
	;


type 
	: INT   {  $<ourinfo>1.type = 2 ; $<ourinfo>$=$<ourinfo>1; typeno=2;printf("type1:%d,type2:%d\n",$<ourinfo>1.type,$<ourinfo>$);}
	| CHAR  {  $<ourinfo>1.type = 1 ; $<ourinfo>$=$<ourinfo>1; typeno=1}
	| FLOAT {  $<ourinfo>1.type = 3 ; $<ourinfo>$=$<ourinfo>1; typeno=3}
	| VOID  {  $<ourinfo>1.type = 0 ; $<ourinfo>$=$<ourinfo>1; typeno=0}
	| STRING {  $<ourinfo>1.type = 4 ; $<ourinfo>$=$<ourinfo>1; typeno=4} 
	| BOOL {  $<ourinfo>1.type = 5 ; $<ourinfo>$=$<ourinfo>1; typeno=5} 
	;

variable
	: IDENTIFIER {  $<ourinfo>$.name=$<ourinfo>$.name; $<ourinfo>$.type=typeno;  printf("%d\n",$<ourinfo>$.type); }
	;

argument 
	: type variable
	| variable
	;


statements 
		: multiplearguments 
		| CONST argument ASSIGN number 
		| CONST argument ASSIGN string 
		| multiplearguments ASSIGN string  
		| multiplearguments ASSIGN expr	
		| variable INC
		| variable DEC
		| condition // shouldnot be here
		;

multiplearguments
	: argument
	|  argument multipledeclarations
	;

multipledeclarations
	: COMMA variable
	| COMMA variable multipledeclarations
	;

comparsions
	: EQ | GE | LE | L | G | NEQ;

BOOLEANS
	: TRUE
	| FALSE

condition
	: expr comparsions expr
	| IDENTIFIER EQ BOOLEANS
	;
	
logicals
	: AND
	| OR
	;
number
	: NUM	
	| DECIMAL	
	;
	
string
	: EXPSTR 
	| EXPCHAR 
	;

operation
	: ADD 
	| SUB 
	;

expr 
    : expr operation factor
	| term


	;

term
	: term MUL factor 
	| term DIV factor
	| factor
	;

factor
	: number
	| variable //a= a+3
	| OP expr CP
	;


%%




void yyerror (char const *s) {
	fprintf (stderr, "%s\n", s);
}

extern FILE *yyin;

int main()
{
	yyin=fopen("input.c","r");
	
	yyparse();
	
	fclose(yyin);
	
	return 0;
}





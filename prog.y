
  
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
%token  EQ LE GE AND OR L G NEQ
%token  ASSIGN
%token  SS
%token  ADD SUB MUL DIV INC DEC REM
%token  XOR BitwiseAnd BitwiseOR
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
	| STRING {  $<ourinfo>1.type = 4 ; $<ourinfo>$=$<ourinfo>1; typeno=4} 
	| BOOL {  $<ourinfo>1.type = 5 ; $<ourinfo>$=$<ourinfo>1; typeno=5} 
	;


ReturnType
	: VOID
	| type
	;

variable
	: IDENTIFIER {  $<ourinfo>$.name=$<ourinfo>$.name; $<ourinfo>$.type=typeno;  printf("%d\n",$<ourinfo>$.type); }
	;

argument 
	: type variable
	| variable
	;


statements 
		: common 
		| multiplearguments ASSIGN expr	
		| variable ASSIGN string
		| variable ASSIGN expr
		| variable INC
		| variable DEC
		| multipleConditions // TODO multipleConditions must be inside if block
		;

common
	: multiplearguments 
	| CONST type variable ASSIGN number 
	| CONST type variable ASSIGN string 
	| multiplearguments ASSIGN string  
	;

multiplearguments
	: type variable
	| type variable multipledeclarations
	;

multipledeclarations
	: COMMA variable
	| COMMA variable multipledeclarations
	;

comparsions
	: Equals
	| GE 
	| LE 
	| L 
	| G 
	;

Equals
	: EQ
	| NEQ
	;
BitOperations
	: XOR
	| BitwiseOR
	| BitwiseAnd
	;

BOOLEANS
	: TRUE
	| FALSE
	;

multipleConditions
	: condition
	| condition logicals multipleConditions
	;

condition //(o/p of function or variable == bool )eq boolean 
	: expr comparsions expr  {printf("%d\n",$<ourinfo>$.type);}
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

MathOperations
	: ADD 
	| SUB
	;
operations
	: MathOperations
	| BitOperations
	;

expr 
    : expr BitOperations factor
	| expr2
	| BOOLEANS
	;

expr2
	: expr2  MathOperations factor
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
	int yydebug=1;
	yyparse();
	
	fclose(yyin);
	
	return 0;
}





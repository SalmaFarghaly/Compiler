
  
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
		char name[10];
        char* value;
		int quadvalue;
		char * quad;
	    char  variable;
		char * string;    
        int  type;
    }ourinfo;
}  

%start block
%token  <ourinfo>IDENTIFIER 
%token  <ourinfo> NUM
%token  <ourinfo> DECIMAL 
%token  <ourinfo> EXPCHAR
%token  <ourinfo> EXPSTR 
%token  CHAR INT FLOAT DOUBLE STRING VOID RETURN BOOL
%token  EQ LE GE AND OR L G NEQ
%token  ASSIGN
%token  FUNCNAME
%token  ADD SUB MUL DIV INC DEC REM
%token  XOR BitwiseAnd BitwiseOR
%token SEMICOLON COMMA IF THEN CONST
%token  OP CP OB CB
%token FALSE TRUE



%%

block
	: line
	|line block

	| ob line CB // figure it out
	| ob line CB block
	
	| ob line block CB
	| ob line block CB block
	;

line
	: statements SEMICOLON
	| function_decl
	| function_def
	;



function_decl
	: type variable OP parameters CP SEMICOLON { printf("Function %s declared\n", $<ourinfo>3.name);}
	;

function_def
	: type variable OP parameters CP ob line CB { printf("Function %s definition\n", $<ourinfo>2.name);}

parameters: type variable | type variable multipleparameters {strcpy($<ourinfo>$.name, "test");}

multipleparameters: COMMA type variable | COMMA type variable multipleparameters 


ob: OB {/* handle beginning of new scope */ printf("new scope\n");};

type 
	: INT   {  
			$<ourinfo>1.type = 2 ; 
			$<ourinfo>$=$<ourinfo>1; 
			typeno=2;
			printf("type1:%d,type2:%d\n",$<ourinfo>1.type,$<ourinfo>$);
			}

	| CHAR  {  
			$<ourinfo>1.type = 1 ; 
			$<ourinfo>$=$<ourinfo>1; 
			typeno=1;
			}
	| FLOAT {  $<ourinfo>1.type = 3 ; $<ourinfo>$=$<ourinfo>1; typeno=3;}
	| VOID  {  $<ourinfo>1.type = 0 ; $<ourinfo>$=$<ourinfo>1; typeno=0;}
	| STRING {  $<ourinfo>1.type = 4 ; $<ourinfo>$=$<ourinfo>1; typeno=4;} 
	| BOOL {  $<ourinfo>1.type = 5 ; $<ourinfo>$=$<ourinfo>1; typeno=5;} 
	;


ReturnType
	: VOID
	| type
	;

variable
	: IDENTIFIER {  strcpy($<ourinfo>$.name, $<ourinfo>1.name); $<ourinfo>$.type=typeno;  printf("%s\n",$<ourinfo>$.name); printf("%d\n",$<ourinfo>$.type); }
	;


argument 
	: type variable
	| variable
	;


statements 
		: commondeclarations 
		| multiplearguments ASSIGN expr	
		| variable ASSIGN string
		| variable ASSIGN expr
		| variable INC
		| variable DEC
		| multipleConditions // TODO multipleConditions must be inside if block
		/*| ReturnStmt*/
		;

commondeclarations
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
	
	int value;
	scanf("%d", &value);
	
	return 0;
}





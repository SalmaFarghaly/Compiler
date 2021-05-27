
%{	
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex();
	void yyerror (char *s);
	int typeno;
%}
%union {
  struct info{ 
		char name[10];
        char* value;
		int quadvalue;
		char * quad;
	    char  IDENTIFIER;
		char * string;    
        int  type;
    }ourinfo;
}  

%start program
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
%token SEMICOLON COMMA 
%token IF THEN CONST ELSE 
%token WHILE REPEAT UNTIL FOR SWITCH CASE
%token  OP CP OB CB
%token FALSE TRUE



%%

program
	: braced_block
	//| unbraced_block
	//| unbraced_block program
	| braced_block program
	;


//unbraced_block
//	: IF
//	;

braced_block
	: OB statements CB
	;

statements
	: statement
	| statement statements
	;

statement 
		: var_declaration SEMICOLON
		| const_declaration SEMICOLON
		| identifier_assignment SEMICOLON
		| variable INC SEMICOLON
		| variable DEC SEMICOLON
		| multiple_conditions SEMICOLON // TODO multipleConditions must be inside if block
		| function_decl
		| function_def
		| if_stmt
		| while_loop
		;

var_declaration
	: type variable var_assignment
	| type variable var_assignment multiple_var_declarations
	;

var_assignment
	: /*empty*/  //for declaring variables without assigning it
	| ASSIGN string  
    | ASSIGN expr
	;

multiple_var_declarations
	: COMMA variable 
	| COMMA variable var_assignment multiple_var_declarations
	;


const_declaration
	: CONST type variable const_assignment
	| CONST type variable const_assignment multiple_const_declarations
	;

multiple_const_declarations
	: COMMA variable const_assignment
	| COMMA variable const_assignment multiple_const_declarations
	;

const_assignment
	: ASSIGN number
	| ASSIGN string
	;

identifier_assignment
	: variable ASSIGN string
	| variable ASSIGN expr
	;


ob: OB {/* handle beginning of new scope */ printf("new scope\n");};

function_decl
	: type variable OP func_params CP SEMICOLON //no default values for arguments
	| VOID variable OP func_params CP SEMICOLON
	;

function_def
	: type variable OP func_params CP braced_block
	| VOID variable OP func_params CP braced_block
	;


func_params 
	: 	/*empty*/  // for functions that have no parameters
	| 	type variable  
	| 	type variable multiple_parameters
	;

multiple_parameters
	: COMMA type variable 
	| COMMA type variable multiple_parameters ;

if_stmt
	: IF OP condition CP braced_block
	| IF OP condition CP braced_block ELSE braced_block
	;

while_loop
	: WHILE OP condition CP ob 

type 
	: INT  {  
			$<ourinfo>1.type = 2 ; 
			$<ourinfo>$=$<ourinfo>1; 
			typeno=2;
			printf("type1:%d,type2:%d\n",$<ourinfo>1.type,$<ourinfo>$);
		}
	| CHAR {  
			$<ourinfo>1.type = 1 ; 
			$<ourinfo>$=$<ourinfo>1; 
			typeno=1;
		}
	| FLOAT   {  $<ourinfo>1.type = 3 ; $<ourinfo>$=$<ourinfo>1; typeno=3;}
	| STRING  {  $<ourinfo>1.type = 0 ; $<ourinfo>$=$<ourinfo>1; typeno=4;}
	| BOOL    {  $<ourinfo>1.type = 4 ; $<ourinfo>$=$<ourinfo>1; typeno=5;} 
	;

variable
	: IDENTIFIER {  strcpy($<ourinfo>$.name, $<ourinfo>1.name); $<ourinfo>$.type=typeno;  printf("%s\n",$<ourinfo>$.name); printf("%d\n",$<ourinfo>$.type); }
	;
	
comparsions
	: equals
	| GE 
	| LE 
	| L 
	| G 
	;

equals
	: EQ
	| NEQ
	;

bit_operations
	: XOR
	| BitwiseOR
	| BitwiseAnd
	;

booleans
	: TRUE
	| FALSE
	;

multiple_conditions
	: condition
	| condition logicals multiple_conditions
	;

condition //(o/p of function or IDENTIFIER == bool )eq boolean 
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

math_operations
	: ADD 
	| SUB
	;


expr 
    : expr bit_operations factor
	| expr2
	| booleans
	;

expr2
	: expr2  math_operations factor
	| term 
	;

term
	: term MUL factor 
	| term DIV factor
	| factor
	;

factor
	: number
	| IDENTIFIER //a= a+3
	| OP expr CP
	;
/*
return_stmt
	: RETURN expr 
	| RETURN
	;
*/	


%%

extern FILE *yyin;
void yyerror(char *s){
    extern int yylineno;
    // fprintf(stderr,"At line %s %d ",s,yylineno);  
    fprintf(stderr,"%s",s);  
}





int main()
{
	yyin=fopen("input.c","r");
	int yydebug=1;
	yyparse();
	
	fclose(yyin);
	
	return 0;
}





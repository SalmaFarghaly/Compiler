
%{	
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#define _GNU_SOURCE
	int yylex();
	void yyerror (const char *s);
	int typeno;
	extern int yylineno;
//    extern int column;

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
%error-verbose


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
%token  XOR BitwiseAnd BitwiseOR NOT
%token SEMICOLON COMMA COLON
%token IF THEN CONST ELSE 
%token WHILE DO UNTIL FOR SWITCH CASE DEFAULT BREAK
%token  OP CP OB CB DBL_FORWARD_SLASH
%token FALSE TRUE END



%%

program															// Note that an empty file or file with comments only will not parse successfully
	: braced_block	{printf("Reduced to braced_block\n");}
	| statement	{printf("Reduced to statement\n");}
	| statement program	{printf("Reduced to statement . program\n");}
	| braced_block program	{printf("Reduced to braced_block . program\n");}
	//| END {printf("end of fileeeeeeeeeee"); return;}
	;


braced_block
	: OB CB
	| OB statements CB
	;

statements
	: statement
	| statement statements
	;

statement
	: other_statements SEMICOLON
	| func_statements
	| ctrl_statements
	| return_stmt
	| break_stmt // It must only be allowed inside loops and switch cases. 
	| error SEMICOLON { yyerrok;}

	;


other_statements
	: expression_statements
	| declaration_statements
	;

return_stmt
	: RETURN SEMICOLON	{printf("reduced to return_stmt\n");}
	| RETURN expr SEMICOLON
	;

break_stmt
	: BREAK SEMICOLON 
	;

expression_statements
	: identifier_assignment
	| variable INC
	| variable DEC
	| INC variable
	| DEC variable
	//| multiple_conditions // TODO multipleConditions must be inside if block
	;

declaration_statements
	: var_declaration
	| const_declaration
	;

func_statements
	: func_decl
	| func_def
	| func_call SEMICOLON
	;

ctrl_statements
	: if_stmt
	| while_loop
	| do_while
	| for_loop
	| switch_stmt
	;

var_declaration
	: type variable var_assignment 
	| type variable var_assignment multiple_var_declarations
	;

var_assignment
	: /*empty*/  //for declaring variables without assigning it
	| ASSIGN string  
    | ASSIGN multiple_conditions
	;

multiple_var_declarations
	: COMMA variable var_assignment
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
	: ASSIGN multiple_conditions
	| ASSIGN string

	;

identifier_assignment
	: variable ASSIGN string
	| variable ASSIGN multiple_conditions
	;


ob: OB {/* handle beginning of new scope */ printf("new scope\n");};


// Function Declaration and Definition
func_decl
	: type variable OP func_params CP SEMICOLON //no default values for arguments
	| VOID variable OP func_params CP SEMICOLON
	;

func_def
	: type variable OP func_params CP braced_block
	| VOID variable OP func_params CP braced_block
	;
func_params 
	: 	/*empty*/  // for functions that have no parameters
	| 	type variable  
	| 	type variable multiple_func_params
	;

multiple_func_params
	: COMMA type variable 
	| COMMA type variable multiple_func_params ;


// Function Calls
func_call
	: variable OP func_call_params CP 
	;

func_call_params
	: 	/*empty*/  // for functions that have no parameters
	| 	expr  
	| 	expr multiple_func_call_params
	;

multiple_func_call_params
	: COMMA expr 
	| COMMA expr multiple_func_call_params ;


if_stmt
	: IF OP  multiple_conditions CP braced_block {printf("Reduced to if statement\n");}
	| IF OP  multiple_conditions CP braced_block ELSE braced_block {printf("Reduced to if else\n");}
	;

while_loop
	: WHILE OP  multiple_conditions CP braced_block
	;

do_while
	: DO braced_block WHILE OP  multiple_conditions CP SEMICOLON
	;


for_var_declaration: | var_declaration;
for_multiple_conditions: | multiple_conditions;
for_expression_statements: | expression_statements;

for_loop
	: FOR OP for_var_declaration SEMICOLON for_multiple_conditions SEMICOLON for_expression_statements CP braced_block
	;


multiple_cases
	: case
	| case multiple_cases
	;

case
	: CASE expr COLON braced_block // our own assumption
	| DEFAULT COLON braced_block	// Restricting no. of default statements to one will be handled later
	| CASE expr COLON statements 
	| DEFAULT COLON statements




switch_stmt
	: SWITCH OP expr CP ob multiple_cases CB // Verify using expr here. Check increment/decrement statements
	;
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
	: expr
	| expr comparsions expr  {printf("%d\n",$<ourinfo>$.type);}
	| NOT OP expr logicals expr CP
	| NOT OP expr comparsions expr CP
	| NOT variable
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
    : expr bit_operations term
	| expr2
	| booleans
	;

expr2
	: expr2  math_operations term
	| term 
	;


term
	: term MUL factor 
	| term DIV factor
	| term REM factor
	| factor
	;

factor
	: number
	| variable //a= a+3
	| func_call
	| NOT func_call
	| OP expr CP
	;



%%

extern FILE *yyin;

void yyerror(const char *s)
{
    fprintf(stderr, "line %d: %s\n", yylineno, s);

}




int main()
{
	yyin=fopen("input.c","r");
	//free(lineptr);


	int yydebug=1;
	int value;
	value = yyparse();

	if(value == 0){
		printf("Parsing Successful.\n");
	}
	else{
		printf("Parsing Unsuccessful.\n");
	}


	fclose(yyin);
	return 0;
}





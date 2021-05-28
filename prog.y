
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
%token SEMICOLON COMMA COLON
%token IF THEN CONST ELSE 
%token WHILE DO UNTIL FOR SWITCH CASE DEFAULT
%token  OP CP OB CB
%token FALSE TRUE



%%

program
	: braced_block	{printf("Reduced to braced_block\n");}
	| statement	{printf("Reduced to statement\n");}
	| statement program	{printf("Reduced to statement . program\n");}
	| braced_block program	{printf("Reduced to braced_block . program\n");}
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
	| function_statements
	| ctrl_statements
	;


other_statements
	: expression_statements
	| declaration_statements
	;


expression_statements
	: identifier_assignment
	| variable INC
	| variable DEC
	| multiple_conditions // TODO multipleConditions must be inside if block
	;

declaration_statements
	:  var_declaration
	| const_declaration
	;

function_statements
	: function_decl
	| function_def
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
    | ASSIGN expr
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
	: IF OP other_statements CP braced_block {printf("REduced to if statement");}
	| IF OP other_statements CP braced_block ELSE braced_block {printf("Reduced to if else");}
	;

while_loop
	: WHILE OP other_statements CP braced_block
	;

do_while
	: DO braced_block WHILE OP other_statements CP SEMICOLON
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

	// function call
	// try to test violently

switch_stmt
	: SWITCH OP expr  ob multiple_cases CB // Verify using expr here. Check increment/decrement statements
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
	| expr math_operations factor
	| OP expr CP
	| booleans
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
	int value;
	value = yyparse();

	if(value == 0){
		printf("Parsing Successful.\n");
	}
	else{
		printf("Parsing Unsuccessful.\n");
	}
	int dummy;
    scanf("%d", &dummy); 

	fclose(yyin);
	return 0;
}





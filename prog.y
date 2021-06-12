
%{	

	#include "headers/utilies.h"
	#include "headers/symbol_table.h"
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#define _GNU_SOURCE
	int yylex();
	void yyerror (const char *s);

	int globa=5;
	int typeno;
	int const_flag;
	extern int yylineno;
	void add_quad(char op[10],char arg1[10],char arg2[10],char res[10]);
	void add_var_to_current_scope(int const_flag, int type, char* var_name, char* initializing_val, int initializing_val_type);
	// void newtemp();
	void add_quad2(char op[10],char arg1[10],char arg2[10],char res[10]);
	void construct_quad(char op[10],char arg1[10],char arg2[10],char res[10]);
	void newtemp();
	void newLabel();
	void write_conditionquads();
	void write_barcedquads();


	

	struct scope_tree* tree;
	
	struct quad {
	char op[10];
	char arg1[100];
	char arg2[100];
	char res[100];
	char type[100];} quad[10];



	struct quad quad[10];
	struct quad barcedquad[100];
	int quadarrayptr=0;
	int barcedquadarrayptr=0;
	int i=1;
	char t[10]="t";
	int tIdx=1;

	int labelIdx=1;
	char label[10]="l";
	int srcNo=1;
	int ifIdx=0;
	int resIdx=0;


	char mulCondLabel[10];
	char whileLabel[10];
	char forLabel[10];

	int forExpr=0;
	

%}
%union {
  

  struct Parse attr;
  struct info{ 
		char name[10];
		char token[10];
        char* value;
		int quadvalue;
		char * quad;
	    char  IDENTIFIER;
		char * string;    
		char  variable;
        int  type;
    }ourinfo;

	
}  



%start program
%error-verbose


%token  <ourinfo>IDENTIFIER 
%token  <ourinfo> NUM
%token  <ourinfo> DECIMAL 
%token  <ourinfo> EXPCHAR
%token  <ourinfo >EXPSTR
%token  CHAR INT FLOAT DOUBLE STRING VOID RETURN BOOL  
%token  FUNCNAME
%token  INC DEC 
%token SEMICOLON COLON
%token IF THEN CONST ELSE 
%token WHILE DO UNTIL FOR SWITCH CASE DEFAULT BREAK
%token  OPEN_Parentheses  CLOSED_Parentheses  OPEN_Brackets CLOSED_Brackets DBL_FORWARD_SLASH
%token FALSE TRUE 

%token  <ourinfo> GreaterThan GreaterThan_Or_Equal NotEqual Equal  LessThan LessThan_OR_Equal 
%type  <ourinfo> variable equals
%type  <ourinfo> term
%type  <ourinfo> factor
%type  <ourinfo> multiple_conditions logicals AND OR
%type  <ourinfo> condition
%type  <ourinfo> expr
%type  <ourinfo> expr2
%type  <ourinfo> number
%type  <ourinfo> math_operations
%type  <ourinfo> bit_operations
%type  <ourinfo> SUB
%type  <ourinfo> ADD
%type  <ourinfo> XOR BitwiseAnd BitwiseOR comparsions
%type  <ourinfo> string
%type  <ourinfo> var_assignment multiple_var_declarations
// %type  <ourinfo> const_assignment multiple_const_declarations




%left AND OR ADD SUB MUL DIV REM
%left Equal LessThan_OR_Equal GreaterThan_Or_Equal 
%left  XOR BitwiseAnd BitwiseOR COMMA

%right NOT ASSIGN

%%

program															// Note that an empty file or file with comments only will not parse successfully
	: braced_block	{printf("Reduced to braced_block\n");}
	| statement	{printf("Reduced to statement\n");}
	| statement program	{printf("Reduced to statement . program\n");}
	| braced_block program	{printf("Reduced to braced_block . program\n");}
	//| END {printf("end of fileeeeeeeeeee"); return;}
	;


braced_block
	: ob cb
	| ob statements cb
	| ob braced_block cb
	| ob statements braced_block cb
	| ob braced_block statements cb
	| ob braced_block statements braced_block cb
	| ob statements braced_block statements cb

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
	| variable INC {
		add_quad2("+",$1.name,"1",t);
		add_quad2("=",t,"-",$1.name);
	}
	| variable DEC {
		add_quad2("-",$1.name,"1",t);
		add_quad2("=",t,"-",$1.name);
	}
	| INC variable {
		add_quad2("+",$2.name,"1",t);
		add_quad2("=",t,"-",$2.name);
	}
	| DEC variable {
		add_quad2("-",$2.name,"1",t);
		add_quad2("=",t,"-",$2.name);
	}
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



if_stmt
	: IF OPEN_Parentheses  multiple_conditions dummy CLOSED_Parentheses  braced_block {
		add_quad(label,"::"," "," ");
	}
	| IF OPEN_Parentheses  multiple_conditions dummy CLOSED_Parentheses  braced_block {
		char labelTemp[10];
		strcpy(labelTemp,label);
		newLabel();add_quad("jmp",label," "," ");add_quad(labelTemp,"::"," "," ");
		} ELSE braced_block {
		printf("Reduced to if else\n");
		add_quad(label,"::"," "," ");
	}
	;

dummy
	: {		
		newLabel();
		add_quad("cmp",mulCondLabel,"true","-");
		add_quad("jne",label," "," ");
	}

while_loop
	: {newLabel();add_quad(label,"::"," "," ");strcpy(whileLabel,label);} WHILE OPEN_Parentheses   multiple_conditions dummy CLOSED_Parentheses  braced_block
	{
		add_quad("jmp",whileLabel," "," ");
		
		add_quad(label,"::"," "," ");
	}
	;

do_while
	: {newLabel();add_quad(label,"::"," "," ");} DO braced_block WHILE OPEN_Parentheses   multiple_conditions CLOSED_Parentheses  SEMICOLON{
		add_quad("cmp",t,"true"," ");
		add_quad("je",label," "," ");

	}
	;


multiple_conditions
	: condition logicals multiple_conditions{
		$$.type = $1.type;
		newtemp();
		add_quad2($2.name,$1.name,$3.name,t);
		strcpy($$.name,t);
		strcpy(mulCondLabel,t);
	}
	| condition {
		$$.type = $1.type;
		strcpy($$.name,$1.name); 
		strcpy(mulCondLabel,t);
	}
	;

condition //(o/p of function or IDENTIFIER == bool )eq boolean
	: expr {strcpy($$.name,$1.name); $$.type = $1.type;}
	| expr comparsions expr  {

		newtemp();
		add_quad2($2.name,$1.name,$3.name,t);
		strcpy($$.name,t); 
	}
	| NOT OPEN_Parentheses  expr logicals expr CLOSED_Parentheses
	| NOT OPEN_Parentheses  expr comparsions expr CLOSED_Parentheses 
	| NOT variable
	;

logicals
	: AND {strcpy($$.name,$1.name);}
	| OR {strcpy($$.name,$1.name);}
	;

var_declaration
	: type variable var_assignment { add_var_to_current_scope(const_flag, $<ourinfo>1.type, $2.name, $3.name, $3.type); const_flag = 0;}
	| type variable var_assignment multiple_var_declarations { add_var_to_current_scope(const_flag, $<ourinfo>1.type, $2.name, $3.name, $3.type); const_flag = 0;}
	;

var_assignment
	: /*empty*/  /*for declaring variables without assigning it*/ {$$.type = -1}
	| ASSIGN string {
		strcpy($$.name, $2.name);
		$$.type = $2.type;
		add_quad2("=",$2.name,"-",t);
		add_quad2("=",t,"-",$$.name);
	}
    | ASSIGN multiple_conditions {
		strcpy($$.name, $2.name);
		$$.type = $2.type;
		if($2.name[0]!='t'){
			add_quad2("=",$2.name,"-",t);
			add_quad2("=",t,"-",$$.name);
		}
		else
			add_quad2("=",$2.name,"-",$$.name);
	}
	;

multiple_var_declarations
	: COMMA variable var_assignment {strcpy($$.name,$2.name); 
									 add_var_to_current_scope(const_flag, typeno, $2.name, $3.name, $3.type);
									}
	| COMMA variable var_assignment multiple_var_declarations {strcpy($$.name,$2.name);
																add_var_to_current_scope(const_flag, typeno, $2.name, $3.name, $3.type);
																}
	;

const_modifier: CONST {const_flag = 1;}
const_declaration: const_modifier var_declaration
// const_declaration
// 	: CONST type variable const_assignment  
// 	| CONST type variable const_assignment multiple_const_declarations 
// 	;

// multiple_const_declarations
// 	: COMMA variable const_assignment {strcpy($$.name,$2.name);}
// 	| COMMA variable const_assignment multiple_const_declarations {strcpy($$.name,$2.name);}
// 	;

// const_assignment
// 	: ASSIGN multiple_conditions {
// 		//add_quad("=",$2.name,"-",t);
// 		add_quad("=",$2.name,"-",$$.name);
// 	}
// 	| ASSIGN string {
// 		add_quad("=",$2.name,"-",t);
// 		add_quad("=",t,"-",$$.name);
// 	}

// 	;

identifier_assignment
	: variable ASSIGN string { 

		add_quad2("=",$3.name,"-",t);
		add_quad2("=",t,"-",$1.name);
		}
	| variable ASSIGN multiple_conditions {

		if($3.name[0]!='t'){
			add_quad2("=",$3.name,"-",t);
			add_quad2("=",t,"-",$1.name);
		}
		else
			add_quad2("=",$3.name,"-",$1.name);
		}
	;


ob: OPEN_Brackets { create_scope(tree); printf("New Scope\n");};

cb: CLOSED_Brackets { close_current_scope(tree); };

// Function Declaration and Definition
func_decl
	: type variable OPEN_Parentheses  func_params CLOSED_Parentheses  SEMICOLON //no default values for arguments
	| VOID variable OPEN_Parentheses  func_params CLOSED_Parentheses  SEMICOLON
	;

func_def
	: type variable OPEN_Parentheses  func_params CLOSED_Parentheses  braced_block
	| VOID variable OPEN_Parentheses  func_params CLOSED_Parentheses  braced_block
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
	: variable OPEN_Parentheses  func_call_params CLOSED_Parentheses  
	;

func_call_params
	: 	/*empty*/  // for functions that have no parameters
	| 	expr  
	| 	expr multiple_func_call_params
	;

multiple_func_call_params
	: COMMA expr 
	| COMMA expr multiple_func_call_params ;




for_var_declaration: | var_declaration;
for_multiple_conditions: | multiple_conditions;
for_expression_statements: | expression_statements;

for_loop
	: FOR OPEN_Parentheses for_var_declaration {newLabel();add_quad(label,"::"," "," ");strcpy(forLabel,label);} 
	SEMICOLON for_multiple_conditions {
		  add_quad("cmp",t,"true"," ");
		  newLabel();
		  add_quad("jne",label," "," ");
	  }
	  SEMICOLON {forExpr=1;}for_expression_statements CLOSED_Parentheses  {forExpr=0;} braced_block{
		  write_conditionquads();
		  add_quad("jmp",forLabel," "," ");
		  add_quad(label,"::"," "," ");
	  }
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
	: SWITCH OPEN_Parentheses  expr CLOSED_Parentheses  ob multiple_cases cb // Verify using expr here. Check increment/decrement statements
	;

type 
	: INT	{ $<ourinfo>$.type = type_int; typeno = type_int;}
	| CHAR	{ $<ourinfo>$.type = type_char; typeno = type_char;}
	| FLOAT	{ $<ourinfo>$.type = type_float; typeno = type_float;}
	| STRING	{ $<ourinfo>$.type = type_string; typeno = type_string;}
	| BOOL	{ $<ourinfo>$.type = type_bool; typeno = type_bool;}
	;

variable
	: IDENTIFIER {strcpy($$.name, $1.name);}
	;
	
comparsions
	: equals  {strcpy($$.name,$1.name);}
	| GreaterThan_Or_Equal {strcpy($$.name,$1.name);}
	| LessThan_OR_Equal {strcpy($$.name,$1.name);}
	| LessThan {strcpy($$.name,$1.name);}
	| GreaterThan {strcpy($$.name,$1.name);}
	;

equals
	: Equal  {strcpy($$.name,$1.name);}
	| NotEqual  {strcpy($$.name,$1.name);}
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



number
	: NUM	 {strcpy($$.name,$1.name); $$.type = type_int;}
	| DECIMAL	 {strcpy($$.name,$1.name); $$.type = type_float;}
	;
	
string
	: EXPSTR {strcpy($$.name,$1.name); $$.type = type_string;}
	| EXPCHAR {strcpy($$.name,$1.name); $$.type = type_char;}
	;

math_operations
	: ADD {strcpy($$.name,$1.name);}
	| SUB {strcpy($$.name,$1.name);}
	;

expr 
    : expr bit_operations expr2 { // Should we limit bitwise operations to integer values only?
		add_quad($2.name,$1.name,$3.name,t);
		strcpy($$.name,t);
	}
	| expr2 {strcpy($$.name,$1.name); $$.type = $1.type;}
	| booleans
	;

expr2
	: expr2  math_operations term {
		add_quad2($2.name,$1.name,$3.name,t);
		strcpy($$.name,t);
		if($1.type == type_float || $3.type == type_float){
			$$.type = type_float;
		} else{
			$$.type = type_int;
		}
	}
	|  term  {strcpy($$.name,$1.name); $$.type = $1.type;}
	;


term
	: term MUL factor {

		add_quad2("*",$1.name,$3.name,t);
		strcpy($$.name,t);
		if($1.type == type_float || $<ourinfo>2.type == type_float){
			$$.type = type_float;
		} else{
			$$.type = type_int;
		}
	}
	| term DIV factor {
		add_quad2("/",$1.name,$3.name,t);
		strcpy($$.name,t);
		$$.type = type_float;
	}
	| term REM factor{
		add_quad2("%",$1.name,$3.name,t);
		strcpy($$.name,t);
		$$.type = type_int;
	}
	| factor {strcpy($$.name,$1.name); $$.type=$1.type;}
	;

factor
	: number {strcpy($$.name,$1.name); $$.type = $1.type;}
	| variable {strcpy($$.name,$1.name); }
	| func_call
	| NOT func_call
	| OPEN_Parentheses  expr CLOSED_Parentheses {strcpy($$.name,$2.name);}
	;



%%

extern FILE *yyin;
extern FILE* yyout;

//to create new variable 't'
void newtemp()
{
	char temp[10];
	sprintf(temp,"%d",tIdx++);
	strcpy(t,"t");
	strcat(t,temp);
	
}
void newLabel()
{
	char temp[10];
	sprintf(temp,"%d",labelIdx++);
	strcpy(label,"l");
	strcat(label,temp);
	
}


void add_quad2(char op[10],char arg1[10],char arg2[10],char res[10]){
	if(forExpr==0){
		add_quad(op,arg1,arg2,res);
	}
	else{
		construct_quad(op,arg1,arg2,res);
	}
}

void add_quad(char op[10],char arg1[10],char arg2[10],char res[10])
{

	fprintf(yyout,"\n%d\t%s\t%s\t%s\t%s\n",srcNo++,op,arg1,arg2,res);
}


void write_conditionquads()
{

	for(int j=0;j<quadarrayptr;j++){
		if (strcmp(quad[j].op," ")==1)
		fprintf(yyout,"\n%d\t%s\t%s\t%s\t%s\n",srcNo++,quad[j].op,quad[j].arg1,quad[j].arg2,quad[j].res);
	}
	quadarrayptr=0;
}


void construct_quad(char op[10],char arg1[10],char arg2[10],char res[10]){


	memcpy(quad[quadarrayptr].op,op,strlen(op)+1);
	memcpy(quad[quadarrayptr].arg1,arg1,strlen(arg1)+1);
	memcpy(quad[quadarrayptr].arg2,arg2,strlen(arg2)+1);
	memcpy(quad[quadarrayptr].res,res,strlen(res)+1);

	quadarrayptr++;
}

void yyerror(const char *s)
{
    fprintf(stderr, "line %d: %s\n", yylineno, s);

}







int main()
{

	yyin=fopen("c_files/input2.c","r");
	//free(lineptr);

	yyout=fopen("out.txt","w");
	fprintf(yyout,"St.No\top\targ1\targ2\tres\n");
	
	// Initialize Tree with global symbol table
	tree = malloc(sizeof(struct scope_tree));
	tree->root = malloc(sizeof(struct symbol_table));
	tree->current_scope =tree->root;
	print(tree->current_scope);

	int yydebug=1;
	int value;
	value = yyparse();

	if(value == 0){
		printf("Parsing Successful.\n");
		//display();
	}
	else{
		printf("Parsing Unsuccessful.\n");
	}

	char* y;
	scanf("%s", &y);
	fclose(yyin);
	return 0;
}


void add_var_to_current_scope(int const_flag, int type, char* var_name, char* initializing_val, int initializing_val_type)
{
	if (search(tree->current_scope, var_name) != NULL) 
	{ //Search for variable name only in current scope
		printf("Error: Re-declaration of existing variable %s\n", var_name); 
	} 
	else if (initializing_val_type == -1)
	{
		append(tree->current_scope, var_name, VAR, type, const_flag,  "\0");
	} 
	else if(type == initializing_val_type)
	{ // If non-existent, append it to current scope
		append(tree->current_scope, var_name, VAR, type, const_flag, initializing_val);
	}
	else
	{
		printf("Error: Mismatched initializing value of type %s for variable %s of type %s\n", types[initializing_val_type], var_name, types[type]); 
	}
	print(tree->current_scope);
}

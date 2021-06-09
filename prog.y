
%{	

	#include "utilies.h"
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#define _GNU_SOURCE
	int yylex();
	void yyerror (const char *s);


	int typeno;
	extern int yylineno;
	//char * addquad(char a,char* b, char* c,char* result);
	//void addquad2(char ,char* , char , char*);
	void add_quad(char op[10],char arg1[10],char arg2[10],char res[10]);
	// void newtemp();
	FILE* yyout;
	//char ob[10]="T";




	struct quad quad[10];
	int quadarrayptr=0;
	int i=1;
	char t[10]="t";
	int tIdx=1;
	int srcNo=1;
	

%}
%union {
  

  struct Parse attr;

  struct info{ 
		char name[10];
        char* value;
		int quadvalue;
		char * quad;
	    char  IDENTIFIER;
		char * string;    
		char  variable;
        int  type;
    }ourinfo;


	//char op[10];
	//char dtype[10];
	//struct quad q1;
	//int pos;
	//struct ParseTreeNode attr;
	//struct IntListNode *list;
	//int int1;
	//char name[10];
	
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


%type  <ourinfo> variable
%type  <ourinfo> term
%type  <ourinfo> factor
%type  <ourinfo> multiple_conditions
%type  <ourinfo> condition
%type  <ourinfo> expr
%type  <ourinfo> expr2
%type  <ourinfo> number
%type  <ourinfo> math_operations
%type  <ourinfo> bit_operations
%type  <ourinfo> SUB
%type  <ourinfo> ADD
%type  <ourinfo> XOR BitwiseAnd BitwiseOR
%type  <ourinfo> string
%type  <ourinfo> var_declaration var_assignment multiple_var_declarations
%type  <ourinfo> const_declaration const_assignment multiple_const_declarations




%left AND OR ADD SUB MUL DIV REM
%left Equal LessThan_OR_Equal GreaterThan_Or_Equal  LessThan GreaterThan NotEqual
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
	: OPEN_Brackets CLOSED_Brackets
	| OPEN_Brackets statements CLOSED_Brackets
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
	: type variable var_assignment {strcpy($$.name,$2.name);}
	| type variable var_assignment multiple_var_declarations {strcpy($$.name,$2.name);}
	;

var_assignment
	: /*empty*/  //for declaring variables without assigning it
	| ASSIGN string {
		add_quad("=",$2.name,"-",t);
		add_quad("=",t,"-",$$.name);
	}
    | ASSIGN multiple_conditions {
		add_quad("=",t,"-",$$.name);
	}
	;

multiple_var_declarations
	: COMMA variable var_assignment {strcpy($$.name,$2.name);}
	| COMMA variable var_assignment multiple_var_declarations {strcpy($$.name,$2.name);}
	;


const_declaration
	: CONST type variable const_assignment {add_quad("=",t,"-",$3.name);}
	| CONST type variable const_assignment multiple_const_declarations {add_quad("=",t,"-",$3.name);}
	;

multiple_const_declarations
	: COMMA variable const_assignment {strcpy($$.name,$2.name);}
	| COMMA variable const_assignment multiple_const_declarations {strcpy($$.name,$2.name);}
	;

const_assignment
	: ASSIGN multiple_conditions {
		// add_quad("=",$2.name,"-",t);
		add_quad("=",t,"-",$$.name);
	}
	| ASSIGN string {
		add_quad("=",$2.name,"-",t);
		add_quad("=",t,"-",$$.name);
	}

	;

identifier_assignment
	: variable ASSIGN string { 

		add_quad("=",$3.name,"-",t);
		add_quad("=",t,"-",$1.name);
		}
	| variable ASSIGN multiple_conditions {

		//add_quad("=",$2.name,"-",t);
		add_quad("=",t,"-",$1.name);
		}
	;


ob: OPEN_Brackets {/* handle beginning of new scope */ printf("new scope\n");};


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


if_stmt
	: IF OPEN_Parentheses   multiple_conditions CLOSED_Parentheses  braced_block {printf("Reduced to if statement\n");}
	| IF OPEN_Parentheses   multiple_conditions CLOSED_Parentheses  braced_block ELSE braced_block {printf("Reduced to if else\n");}
	;

while_loop
	: WHILE OPEN_Parentheses   multiple_conditions CLOSED_Parentheses  braced_block
	;

do_while
	: DO braced_block WHILE OPEN_Parentheses   multiple_conditions CLOSED_Parentheses  SEMICOLON
	;


for_var_declaration: | var_declaration;
for_multiple_conditions: | multiple_conditions;
for_expression_statements: | expression_statements;

for_loop
	: FOR OPEN_Parentheses  for_var_declaration SEMICOLON for_multiple_conditions SEMICOLON for_expression_statements CLOSED_Parentheses  braced_block
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
	: SWITCH OPEN_Parentheses  expr CLOSED_Parentheses  ob multiple_cases CLOSED_Brackets // Verify using expr here. Check increment/decrement statements
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
	: IDENTIFIER {strcpy($<ourinfo>$.name, $<ourinfo>1.name); $<ourinfo>$.type=typeno;  printf("%s\n",$<ourinfo>$.name); printf("%d\n",$<ourinfo>$.type); }
	;
	
comparsions
	: equals
	| GreaterThan_Or_Equal 
	| LessThan_OR_Equal 
	| LessThan 
	| GreaterThan 
	;

equals
	: Equal
	| NotEqual
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
	: condition {strcpy($$.name,$1.name)}
	// | condition logicals multiple_conditions
	;

condition //(o/p of function or IDENTIFIER == bool )eq boolean
	: expr {strcpy($$.name,$1.name)}
//	| expr comparsions expr  {printf("%d\n",$<ourinfo>$.type);}
//	| NOT OPEN_Parentheses  expr logicals expr CLOSED_Parentheses 
//	| NOT OPEN_Parentheses  expr comparsions expr CLOSED_Parentheses 
//	| NOT variable
	;

logicals
	: AND
	| OR
	;

number
	: NUM	 {strcpy($$.name,$1.name);}
	| DECIMAL	 {strcpy($$.name,$1.name);}
	;
	
string
	: EXPSTR {strcpy($$.name,$1.name);}
	| EXPCHAR {strcpy($$.name,$1.name);}
	;

math_operations
	: ADD {strcpy($$.name,$1.name);}
	| SUB {strcpy($$.name,$1.name);}
	;

expr 
    : expr bit_operations expr2 {
		add_quad($2.name,$1.name,$3.name,t);
		strcpy($$.name,t);
	}
	| expr2 {strcpy($$.name,$1.name);}
//	| booleans
	;

expr2
	: expr2  math_operations term {
		add_quad($2.name,$1.name,$3.name,t);
		strcpy($$.name,t);
	}
	|  term  {strcpy($$.name,$1.name);}
	;


term
	: term MUL factor {
		// newtemp();
		//printf("in term Mul %s\n",t)
		add_quad("*",$1.name,$3.name,t);
		strcpy($$.name,t);
	}
	| term DIV factor {
		add_quad("/",$1.name,$3.name,t);
		strcpy($$.name,t);
	}
	| term REM factor{
		add_quad("%",$1.name,$3.name,t);
		strcpy($$.name,t);
	}
	| factor {strcpy($$.name,$1.name);}
	;

factor
	: number {strcpy($$.name,$1.name);}
	| variable {strcpy($$.name,$1.name);}
//	| func_call
//	| NOT func_call
	| OPEN_Parentheses  expr CLOSED_Parentheses {strcpy($$.name,$2.name);}
	;



%%

extern FILE *yyin;


//to create new variable 't'
void newtemp()
{
	char temp[10];
	sprintf(temp,"%d",tIdx++);
	strcpy(t,"t");
	strcat(t,temp);
	
}

void add_quad(char op[10],char arg1[10],char arg2[10],char res[10])
{

	fprintf(yyout,"\n%d\t%s\t%s\t%s\t%s\n",srcNo++,op,arg1,arg2,res);
}

void yyerror(const char *s)
{
    fprintf(stderr, "line %d: %s\n", yylineno, s);

}

void display()
{
	int j;
	for(j=0;j<i;j++)
	{
		/*if(strcmp(quad[j].op,"")==0)
		{
			char buffer[10];
			sprintf(buffer,"%d",i);
			strcpy(quad[j].res,"goto(");
			strcat(quad[j].res,buffer);
			strcat(quad[j].res,")");
		}*/
		fprintf(yyout,"\n%d\t%s\t%s\t%s\t%s\n",j,quad[j].op,quad[j].arg1,quad[j].arg2,quad[j].res);
	}	
}



/*void addquad2(char a,char * b, char c,char* result)
{
   
 
    fprintf(yyout,"\t result %s \t\t\t  operator %c \t\t\t   operand1 %s \t\t\t  operand2 %c \n", strtok(result,";"), a, strtok(b,";"), c);

   
}*/

int main()
{

	yyin=fopen("quad.c","r");
	//free(lineptr);

	yyout=fopen("out.txt","w");
	fprintf(yyout,"St.No\top\targ1\targ2\tres\n");
	int yydebug=1;
	int value;
	value = yyparse();

	if(value == 0){
		printf("Parsing Successful.\n");
		display();
	}
	else{
		printf("Parsing Unsuccessful.\n");
	}


	fclose(yyin);
	return 0;
}





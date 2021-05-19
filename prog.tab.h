
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IDENTIFIER = 258,
     NUM = 259,
     DECIMAL = 260,
     EXPCHAR = 261,
     EXPSTR = 262,
     CHAR = 263,
     INT = 264,
     FLOAT = 265,
     DOUBLE = 266,
     STRING = 267,
     VOID = 268,
     RETURN = 269,
     EQ = 270,
     LE = 271,
     GE = 272,
     AND = 273,
     OR = 274,
     XOR = 275,
     ASSIGN = 276,
     L = 277,
     G = 278,
     NEQ = 279,
     ADD = 280,
     SUB = 281,
     MUL = 282,
     DIV = 283,
     INC = 284,
     DEC = 285,
     REM = 286,
     SEMICOLON = 287,
     COMMA = 288,
     IF = 289,
     THEN = 290,
     CONST = 291,
     OP = 292,
     CP = 293,
     OB = 294,
     CB = 295
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 11 "prog.y"

  struct info{ 
		char* name;
        char* value;
		int quadvalue;
		char * quad;
	    char  variable;
		char * string;    
        int  type;
    }ourinfo;



/* Line 1676 of yacc.c  */
#line 106 "prog.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;



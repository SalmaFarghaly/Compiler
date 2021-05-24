
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
     BOOL = 270,
     EQ = 271,
     LE = 272,
     GE = 273,
     AND = 274,
     OR = 275,
     XOR = 276,
     ASSIGN = 277,
     L = 278,
     G = 279,
     NEQ = 280,
     ADD = 281,
     SUB = 282,
     MUL = 283,
     DIV = 284,
     INC = 285,
     DEC = 286,
     REM = 287,
     SEMICOLON = 288,
     COMMA = 289,
     IF = 290,
     THEN = 291,
     CONST = 292,
     OP = 293,
     CP = 294,
     OB = 295,
     CB = 296,
     FALSE = 297,
     TRUE = 298
   };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define NUM 259
#define DECIMAL 260
#define EXPCHAR 261
#define EXPSTR 262
#define CHAR 263
#define INT 264
#define FLOAT 265
#define DOUBLE 266
#define STRING 267
#define VOID 268
#define RETURN 269
#define BOOL 270
#define EQ 271
#define LE 272
#define GE 273
#define AND 274
#define OR 275
#define XOR 276
#define ASSIGN 277
#define L 278
#define G 279
#define NEQ 280
#define ADD 281
#define SUB 282
#define MUL 283
#define DIV 284
#define INC 285
#define DEC 286
#define REM 287
#define SEMICOLON 288
#define COMMA 289
#define IF 290
#define THEN 291
#define CONST 292
#define OP 293
#define CP 294
#define OB 295
#define CB 296
#define FALSE 297
#define TRUE 298




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 11 "prog.y"

  struct info{ 
		char name[10];
        char* value;
		int quadvalue;
		char * quad;
	    char  variable;
		char * string;    
        int  type;
    }ourinfo;



/* Line 1676 of yacc.c  */
#line 152 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;



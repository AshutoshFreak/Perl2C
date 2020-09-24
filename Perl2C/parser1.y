%{
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include "cgen.h"
// #define YYSTYPE int
extern int yylex(void);
extern int line_num;
extern FILE *yyin;
extern int yylineno;
// extern yylval; // declare yylval which is to be used in lexer.l
%}


// %union {
//   int i;
//   std::string *string;
// }

%token TK_EOF 0
%token ERROR_MESSAGE

/* keywords */
%token KW_STATIC
%token KW_TRUE
%token KW_FALSE
%token KW_DO
%token KW_IF
%token KW_NOT
%token KW_BOOLEAN
%token KW_BREAK
%token KW_ELSE
%token KW_AND
%token KW_INTEGER
%token KW_STRING
%token KW_CONTINUE
%token KW_FOR
%token KW_MOD
%token KW_CHARACTER
%token KW_VOID
%token KW_RETURN
%token KW_END
%token KW_BEGIN
%token KW_REAL
%token KW_WHILE
%token KW_OR
%token KW_MAIN
%token KW_READSTRING
%token KW_READINTEGER
%token KW_READREAL
%token KW_WRITESTRING
%token KW_WRITEINTEGER
%token KW_WRITEREAL

%token VARIABLE
%token IDENTIFIER
%token CONSTANT_STRING
%token POSITIVEINT
%token REAL

%token OP_ADDSUB
%token OP_INCDEC
%token OP_BITWISE_OR
%token OP_XOR
%token OP_BITWISE_AND

%token OP_MULT
%token OP_DIVIS
%token OP_REM
%token OP_EQUAL
%token OP_EQUALITY
%token OP_RELTIONAL
%token OP_SHIFT

%token OP_ASSIGNMENT
%token OP_SEMICOLON
%token OP_LEFT_PARENTHESIS
%token OP_RIGHT_PARENTHESIS
%token OP_TILDE
%token OP_COMMA
%token OP_LEFT_BRACKET
%token OP_RIGHT_BRACKET

%token OP_NOT

// New for perl
%token LEFT_CURLY_BRACKET
%token RIGHT_CURLY_BRACKET
%token KW_SUB
%token KW_FOR_EACH
%token KW_UNTIL
%token POSITIVE_INT
%token OP_DIFFERENT
%token REGEX_OPERATOR
%token NEG_REGEX_OPERATOR
%token DOT_OPERATOR
%token SPL_LIST_ARR_VAR
%token T_ASSIGN_OPER

// New from sahu
%token OP_COLON
%token OP_QUESTION
%token KW_PRINT
%token DeclarationList
%token OP_RELATIONAL

%left OP_BITWISE_OR KW_OR
%left OP_BITWISE_AND KW_AND
%left OP_EQUAL OP_NOTEQUAL OP_GREATER OP_GREATEROREQUAL OP_LESSOREQUAL OP_LESS
%left OP_PLUS OP_MINUS
%left OP_MULT OP_DIVIS KW_MOD KW_DIV
%left OP_EQUALITY OP_RELTIONAL OP_SHIFT

%right OP_NOT
%right KW_NOT
%right KW_WHILE
%right KW_THEN KW_ELSE


// Type declaration
// %type <i> exp
// %type <i> POSITIVE_INT
// %type <string> program

// Maths evaluation
// |exp { printf("program -> exp = %d \n", $1);};
// exp : {printf("EMPTY EXPRESSION");}
// |exp OP_PLUS exp {$$= $3 + $1;}
// |exp OP_MINUS exp {$$= $3 - $1;}
// |exp OP_MULT exp {$$= $3 * $1;}
// |exp OP_DIVIS exp {if($3==0)
// yyerror("Divide by Zero");
// else
// $$=$1/$3;}
// |POSITIVE_INT {$$ = $1; printf("(yylval) : (%d) \n", yylval);}
// ;


// program : {printf("EMPTY !!\n"); } 
// |KW_SUB IDENTIFIER '(' OP_RIGHT_PARENTHESIS { printf("subroutine found, $$ : %d!!\n", $$);} ;
%union{
    // const Base *stmnt;
    double number;
    int integer;
    char* string;
    // std::string *string;
}

// TYPE Declarations
// %type <stmnt> ExtDef ExtDeclaration
// %type <stmnt> FuncDef ParameterList Parameter ParamDeclarator
// %type <stmnt> DeclarationList Declaration DeclarationSpec DeclarationSpec_T InitDeclarator InitDeclaratorList Declarator
// %type <stmnt> StatementList Statement CompoundStatement CompoundStatement_2 SelectionStatement ExpressionStatement JumpStatement IterationStatement
// %type <stmnt> Expression AssignmentExpression ConditionalExpression LogicalOrExpression LogicalAndExpression InclusiveOrExpression ExclusiveOrExpression AndExpression EqualityExpression RelationalExpression ShiftExpression AdditiveExpression MultiplicativeExpression CastExpression UnaryExpression PostfixExpression PostfixExpression2 ArgumentExpressionList PrimaryExpression
// %type <number> Constant T_INT_CONST
// %type <string> T_IDENTIFIER MultDivRemOP UnaryOperator ASSIGN_OPER T_ASSIGN_OPER T_EQ T_AND T_ADDSUB_OP T_TILDE T_NOT T_MULT T_DIV T_REM //T_Operator


%type <string> ROOT IDENTIFIER KW_SUB;
%start ROOT // program

%%

ROOT:
ExtDef { ; }
;

// EXTERNAL DEFINITION

ExtDef:
ExtDeclaration //{ g_root->push($1); printf("$0 : %d", $0);}
|ExtDef ExtDeclaration //{g_root->push($2); }
;

ExtDeclaration:
Declaration //{ $$ = $1; }
|FuncDef //{ $$ = $1; }
;

// FUNCTION DEFINITION

FuncDef:
KW_SUB IDENTIFIER CompoundStatement
;

// DECLARATION

Declaration:
IDENTIFIER OP_LEFT_PARENTHESIS ParameterList OP_RIGHT_PARENTHESIS
;
// in sahu_conversion_parser.y

ParameterList:
                Parameter
        |       ParameterList OP_COMMA Parameter ParameterList_1
                ;

ParameterList_1:
                %empty
        |       OP_COMMA Parameter ParameterList_1
                ;
Parameter:
                VARIABLE
                ;

// ParameterList: "a,b,c"

// CALLING

Calling:
Declaration
|VARIABLE OP_EQUAL Declaration
;

StatementList:
Statement //{ $$ = new StatementList($1);}
|StatementList Statement //{ $$->push($2); }
;

Statement:
CompoundStatement //{ $$ = $1; }
|SelectionStatement //{ $$ = $1; }
|ExpressionStatement //{$$=$1;}
|JumpStatement //{$$=$1;}
|IterationStatement //{$$=$1;}
|PrintStatement //{$$=$1;}
;

CompoundStatement:
LEFT_CURLY_BRACKET CompoundStatement_2 //{ $$ = $2; }
;

CompoundStatement_2:
RIGHT_CURLY_BRACKET //{ $$ = new CompoundStatement; }
|DeclarationList RIGHT_CURLY_BRACKET //{ $$ = new CompoundStatement($1); }
|DeclarationList StatementList RIGHT_CURLY_BRACKET //{ $$ = new CompoundStatement($1, $2); }
|StatementList RIGHT_CURLY_BRACKET //{ $$ = new CompoundStatement($1); }
;

SelectionStatement:
KW_IF OP_LEFT_PARENTHESIS Expression OP_RIGHT_PARENTHESIS Statement //{ $$ = new SelectionStatement($5); }
|KW_IF OP_LEFT_PARENTHESIS Expression OP_RIGHT_PARENTHESIS Statement KW_ELSE Statement //{ $$ = new SelectionStatement($5, $7); }
;

ExpressionStatement:
OP_SEMICOLON //{ $$ = new ExpressionStatement(); }
|Expression OP_SEMICOLON //{ $$ = $1; }
;

JumpStatement:
KW_RETURN ExpressionStatement //{ $$ = $2; }
;

IterationStatement:
KW_WHILE OP_LEFT_PARENTHESIS Expression OP_RIGHT_PARENTHESIS Statement //{ $$ = $5; }
|KW_DO Statement KW_WHILE OP_LEFT_PARENTHESIS Expression OP_RIGHT_PARENTHESIS OP_SEMICOLON //{ $$ = $2; }
|KW_FOR OP_LEFT_PARENTHESIS Expression OP_SEMICOLON Expression OP_SEMICOLON Expression OP_RIGHT_PARENTHESIS Statement //{ $$ = $9; }
;

PrintStatement: KW_PRINT ExpressionStatement
|KW_PRINT CONSTANT_STRING


// Expressions

Expression:
AssignmentExpression //{ $$ = $1; }
;

AssignmentExpression:
ConditionalExpression //{ $$ = $1; }
|UnaryExpression ASSIGN_OPER AssignmentExpression //{ $$ = $1; }
;

ASSIGN_OPER:
T_ASSIGN_OPER //{ ; }
|OP_EQUAL //{ ; }
;

ConditionalExpression:
LogicalOrExpression //{ $$ = $1; }
|LogicalOrExpression OP_QUESTION Expression OP_COLON ConditionalExpression //{ $$ = $1; }
;

LogicalOrExpression:
LogicalAndExpression //{ $$ = $1; }
|LogicalOrExpression KW_OR LogicalAndExpression //{ $$ = $3; }
;

LogicalAndExpression:
InclusiveOrExpression //{ $$ = $1; }
|LogicalAndExpression KW_AND InclusiveOrExpression //{ $$ = $3; }
;

InclusiveOrExpression:
ExclusiveOrExpression //{ $$ = $1; }
|InclusiveOrExpression OP_BITWISE_OR ExclusiveOrExpression //{ $$ = $3; }
;

ExclusiveOrExpression:
AndExpression //{ $$ = $1; }
|ExclusiveOrExpression OP_XOR AndExpression //{ $$ = $3; }
;

AndExpression:
EqualityExpression //{ $$ = $1; }
|AndExpression OP_BITWISE_AND EqualityExpression //{ $$ = $3; }
;

EqualityExpression:
RelationalExpression //{ $$ = $1; }
|EqualityExpression OP_EQUALITY RelationalExpression //{ $$ = $3; }
;

RelationalExpression:
ShiftExpression //{ $$ = $1; }
|RelationalExpression OP_RELATIONAL ShiftExpression //{ $$ = $3; }
;

ShiftExpression:
AdditiveExpression //{ $$ = $1; }
|ShiftExpression OP_SHIFT AdditiveExpression //{ $$ = $3; }
;

AdditiveExpression:
MultiplicativeExpression //{ $$ = $1; }
|AdditiveExpression OP_ADDSUB MultiplicativeExpression //{ $$ = $3; }
;

MultiplicativeExpression:
CastExpression //{ $$ = $1; }
|MultiplicativeExpression MultDivRemOP CastExpression //{ $$ = $3; }
;

MultDivRemOP:
OP_MULT //{ $$ = $1; }
|OP_DIVIS //{ $$ = $1; }
|OP_REM //{ $$ = $1; }
;

CastExpression:
UnaryExpression //{ $$ = $1; }
;

UnaryExpression:
PostfixExpression //{ $$ = $1; }
|OP_INCDEC UnaryExpression //{ $$ = $2; }
|UnaryOperator CastExpression //{ $$ = $2; }
;

UnaryOperator:
OP_BITWISE_AND //{ $$ = $1; }
|OP_ADDSUB //{ $$ = $1; }
|OP_MULT //{ $$ = $1; }
|OP_TILDE //{ $$ = $1; }
|OP_NOT //{ $$ = $1; }
;

PostfixExpression:
PrimaryExpression //{ $$ = $1; }
|PostfixExpression OP_LEFT_BRACKET Expression OP_RIGHT_BRACKET //{ $$ = $3; }
|PostfixExpression OP_LEFT_PARENTHESIS PostfixExpression2 //{ $$ = $3; }
|PostfixExpression DOT_OPERATOR IDENTIFIER //{ $$ = new Expression(); }
|PostfixExpression OP_INCDEC //{ $$ = new Expression(); }
;

PostfixExpression2:
OP_RIGHT_PARENTHESIS //{ $$ = new Expression(); }
|ArgumentExpressionList OP_RIGHT_PARENTHESIS //{ $$ = $1; }
;

ArgumentExpressionList:
AssignmentExpression //{ $$ = $1; }
|ArgumentExpressionList OP_COMMA AssignmentExpression //{ $$ = $3; }
;

PrimaryExpression:
VARIABLE //{ $$ = new Expression(); }
|Constant //{ $$ = new Expression(); }
|OP_LEFT_PARENTHESIS Expression OP_RIGHT_PARENTHESIS //{ $$ = $2; }
;

Constant:
POSITIVE_INT //{ $$ = $1; }
;
%%

char* filename;
int main (int argc, char* argv[])
{
  if (argc == 2) {
    filename = argv[1];
    yyin = fopen(argv[1], "r");
  } else if (argc > 2) {
    printf("Usage: %s filename\n", argv[0]);
    return 1;
  } else {
    filename = "line";
  }
  int tok = yyparse();
  
  if( tok == 0) // 0 means TK_EOF
     printf("Accepted!\n");
  else
     printf("Rejected!\n");
  return 0;
} 

// void yyerror(char const *s, ...) {
//   fprintf(stderr, "%s:%d Parse error:%s\n", filename, yylineno, s);
//   exit(1);
// }

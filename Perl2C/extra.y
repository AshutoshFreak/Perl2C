
ROOT:
ExtDef { ; }
;

// EXTERNAL DEFINITION

ExtDef:
ExtDeclaration // { printf("$0 : %d", $0);} //  g_root->push($1);
|ExtDef ExtDeclaration // {g_root->push($2); }
;

ExtDeclaration:
Declaration // { $$ = $1; }
|FuncDef {printf("FUNCTION DEF");} // { $$ = $1; }
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
Statement // { $$ = new StatementList($1); }
|StatementList Statement // { $$->push($2); }
;

Statement:
CompoundStatement //  { $$ = $1; }
|SelectionStatement // { $$ = $1; }
|ExpressionStatement // {$$=$1;}
|JumpStatement // {$$=$1;}
|IterationStatement // {$$=$1;}
|PrintStatement // {$$=$1;}
;

CompoundStatement:
LEFT_CURLY_BRACKET CompoundStatement_2 // { $$ = $2; }
;

CompoundStatement_2:
RIGHT_CURLY_BRACKET // { $$ = new CompoundStatement; }
|DeclarationList RIGHT_CURLY_BRACKET // { $$ = new CompoundStatement($1); }
|DeclarationList StatementList RIGHT_CURLY_BRACKET //  { $$ = new CompoundStatement($1, $2); }
|StatementList RIGHT_CURLY_BRACKET // { $$ = new CompoundStatement($1); }
;

SelectionStatement:
KW_IF OP_LEFT_PARENTHESIS Expression OP_RIGHT_PARENTHESIS Statement //  { $$ = new SelectionStatement($5); }
|KW_IF OP_LEFT_PARENTHESIS Expression OP_RIGHT_PARENTHESIS Statement KW_ELSE Statement //  { $$ = new SelectionStatement($5, $7); }
;

ExpressionStatement:
OP_SEMICOLON // { $$ = new ExpressionStatement(); }
|Expression OP_SEMICOLON // { $$ = $1; }
;

JumpStatement:
KW_RETURN ExpressionStatement // { $$ = $2; }
;

IterationStatement:
KW_WHILE OP_LEFT_PARENTHESIS Expression OP_RIGHT_PARENTHESIS Statement // { $$ = $5; }
|KW_DO Statement KW_WHILE OP_LEFT_PARENTHESIS Expression OP_RIGHT_PARENTHESIS OP_SEMICOLON // { $$ = $2; }
|KW_FOR OP_LEFT_PARENTHESIS Expression OP_SEMICOLON Expression OP_SEMICOLON Expression OP_RIGHT_PARENTHESIS Statement // { $$ = $9; }
;

PrintStatement: KW_PRINT ExpressionStatement
|KW_PRINT CONSTANT_STRING


// Expressions

Expression:
AssignmentExpression // { $$ = $1; }
;

AssignmentExpression:
ConditionalExpression // { $$ = $1; }
|UnaryExpression ASSIGN_OPER AssignmentExpression // { $$ = $1; }
;

ASSIGN_OPER:
T_ASSIGN_OPER { ; }
|OP_EQUAL { ; }
;

ConditionalExpression:
LogicalOrExpression // { $$ = $1; }
|LogicalOrExpression OP_QUESTION Expression OP_COLON ConditionalExpression // { $$ = $1; }
;

LogicalOrExpression:
LogicalAndExpression // { $$ = $1; }
|LogicalOrExpression KW_OR LogicalAndExpression // { $$ = $3; }
;

LogicalAndExpression:
InclusiveOrExpression // { $$ = $1; }
|LogicalAndExpression KW_AND InclusiveOrExpression // { $$ = $3; }
;

InclusiveOrExpression:
ExclusiveOrExpression // { $$ = $1; }
|InclusiveOrExpression OP_BITWISE_OR ExclusiveOrExpression // { $$ = $3; }
;

ExclusiveOrExpression:
AndExpression // { $$ = $1; }
|ExclusiveOrExpression OP_XOR AndExpression // { $$ = $3; }
;

AndExpression:
EqualityExpression // { $$ = $1; }
|AndExpression OP_BITWISE_AND EqualityExpression // { $$ = $3; }
;

EqualityExpression:
RelationalExpression //  { $$ = $1; }
|EqualityExpression OP_EQUALITY RelationalExpression // { $$ = $3; }
;

RelationalExpression:
ShiftExpression // { $$ = $1; }
|RelationalExpression OP_RELATIONAL ShiftExpression // { $$ = $3; }
;

ShiftExpression:
AdditiveExpression // { $$ = $1; }
|ShiftExpression OP_SHIFT AdditiveExpression // { $$ = $3; }
;

AdditiveExpression:
MultiplicativeExpression // { $$ = $1; }
|AdditiveExpression OP_ADDSUB MultiplicativeExpression // { $$ = $3; }
;

MultiplicativeExpression:
CastExpression // { $$ = $1; }
|MultiplicativeExpression MultDivRemOP CastExpression // { $$ = $3; }
;

MultDivRemOP:
OP_MULT // { $$ = $1; }
|OP_DIVIS // { $$ = $1; }
|OP_REM // { $$ = $1; }
;

CastExpression:
UnaryExpression // { $$ = $1; }
;

UnaryExpression:
PostfixExpression // { $$ = $1; }
|OP_INCDEC UnaryExpression // { $$ = $2; }
|UnaryOperator CastExpression // { $$ = $2; }
;

UnaryOperator:
OP_BITWISE_AND // { $$ = $1; }
|OP_ADDSUB // { $$ = $1; }
|OP_MULT // { $$ = $1; }
|OP_TILDE // { $$ = $1; }
|OP_NOT // { $$ = $1; }
;

PostfixExpression:
PrimaryExpression // { $$ = $1; }
|PostfixExpression OP_LEFT_BRACKET Expression OP_RIGHT_BRACKET // { $$ = $3; }
|PostfixExpression OP_LEFT_PARENTHESIS PostfixExpression2 // { $$ = $3; }
|PostfixExpression DOT_OPERATOR IDENTIFIER // { $$ = new Expression(); }
|PostfixExpression OP_INCDEC // { $$ = new Expression(); }
;

PostfixExpression2:
OP_RIGHT_PARENTHESIS // { $$ = new Expression(); }
|ArgumentExpressionList OP_RIGHT_PARENTHESIS // { $$ = $1; }
;

ArgumentExpressionList:
AssignmentExpression // { $$ = $1; }
|ArgumentExpressionList OP_COMMA AssignmentExpression // { $$ = $3; }
;

PrimaryExpression:
VARIABLE // { $$ = new Expression(); }
|Constant  // { $$ = new Expression(); }
|OP_LEFT_PARENTHESIS Expression OP_RIGHT_PARENTHESIS // { $$ = $2; }
;

Constant:
POSITIVE_INT // { $$ = $1; }
;

%{
#include <assert.h>
#include <stdio.h>
#include <string.h>
/*#include "ptucc_parser.tab.h"*/
#include "cgen.h"
#include "parser.tab.h"


int line_num = 1;
// int yylval = 0; // don't declare here since you have already done in the parser
// #define KW_PROGRAM 300
#define KW_BEGIN 301
#define KW_END 302
#define ERROR_MESSAGE 303
#define TK_EOF 0
// #define IDENTIFIER 304
/* A primitive macro facility: just one macro is allowed to be defined! */
char* mactable[32][2];

/* Return 1 on success, 0 on failure (macro table full) */
// int set_macro(char* name, char* def);

/* Return def for macro, or NULL if no such macro is defined. */
// char* get_macro(char* name);
// int yyval;
%}
%option yylineno


IDENTIFIER 		[a-zA-Z][0-9a-zA-Z_]*
VARIABLE            [$@%]+[0-9a-zA-Z_]+

DIGIT  			[0-9]
POSITIVE_INT 	[0]|[1-9][0-9]*
NUMBER  		{DIGIT}{DIGIT}*
REAL 			{POSITIVE_INT}"."{NUMBER}+[Ee]?[+-]?[1-9]*?

COMMON_CHARS			[^'"\\]
ESCAPE_CHARS			"\\n"|"\\t"|"\\r"|"\\\'"|"\\\""|"\\\\"
CONSTANT_STRING "\""(({COMMON_CHARS}|{ESCAPE_CHARS})*)"\""|"'"(({COMMON_CHARS}|{ESCAPE_CHARS})*)"'"	


WHITESPACE 		[ \t\r]

MULTILINECOMMENTBEGIN ^=[a-zA-Z]
MULTILINECOMMENTEND ^"=cut"$
ASSIGNMENT_OPERATOR (([<>][<>]|[*\/%+\-&^|])[=]|[=])

%x comment
%x line_comment

%%
sub 					{ printf("Line: %d token KW_SUB: '%s'\n", line_num, yytext); return KW_SUB; }
static 					{ printf("Line: %d token KW_STATIC: %s\n", line_num, yytext); return KW_STATIC; }
true					{ printf("Line: %d token BOOLEAN: %s\n", line_num, yytext); return KW_TRUE;}
false					{ printf("Line: %d token BOOLEAN: %s\n", line_num, yytext); return KW_FALSE;}
do 						{ printf("Line: %d token KW_DO: %s\n", line_num, yytext); return KW_DO;}
if 						{ printf("Line: %d token KW_IF: %s\n", line_num, yytext); KW_IF;}
not						{ printf("Line: %d token KW_NOT: %s\n", line_num, yytext); KW_NOT;}
boolean					{ printf("Line: %d token KW_BOOLEAN: %s\n", line_num, yytext); KW_BOOLEAN;}
break					{ printf("Line: %d token KW_BREAK: %s\n", line_num, yytext); return KW_BREAK; }
else					{ printf("Line: %d token KW_ELSE: %s\n", line_num, yytext); return KW_ELSE; }
(and|&&) 						{ printf("Line: %d token KW_AND: %s\n", line_num, yytext); return KW_AND; }
integer 				{ printf("Line: %d token KW_INTEGER: %s\n", line_num, yytext); return KW_INTEGER; }
string 					{ printf("Line: %d token KW_STRING: %s\n", line_num, yytext); return KW_STRING; }
continue 				{ printf("Line: %d token KW_CONTINUE: %s\n", line_num, yytext); return KW_CONTINUE; }
for						{ printf("Line: %d token KW_FOR: %s\n", line_num, yytext); return KW_FOR; }
mod						{ printf("Line: %d token KW_MOD: %s\n", line_num, yytext); return KW_MOD; }
character				{ printf("Line: %d token KW_CHARACTER: %s\n", line_num, yytext); return KW_CHARACTER; }
void					{ printf("Line: %d token KW_VOID: %s\n", line_num, yytext); return KW_VOID; }
return 					{ printf("Line: %d token KW_RETURN: %s\n", line_num, yytext); return KW_RETURN; }
end						{ printf("Line: %d token KW_END: %s\n", line_num, yytext); return KW_END; }
begin 					{ printf("Line: %d token KW_BEGIN: %s\n", line_num, yytext); return KW_BEGIN; }
real					{ printf("Line: %d token KW_REAL: %s\n", line_num, yytext); return KW_REAL; }
while				{ printf("Line: %d token KW_WHILE: %s\n", line_num, yytext); return KW_WHILE; }
(or|\|\|)						{ printf("Line: %d token KW_OR: %s\n", line_num, yytext); return KW_OR; }

foreach					{ printf("Line: %d token KW_FOR_EACH: %s\n", line_num, yytext);  return KW_FOR_EACH;}
until					{ printf("Line: %d token KW_UNTIL: %s\n", line_num, yytext); return KW_UNTIL;}
then                          { printf("Line: %d token KW_THEN: %s\n", line_num, yytext); return KW_THEN;}


{VARIABLE} {printf("Line: %d token VARIABLE %s\n", line_num, yytext); return VARIABLE;}

{IDENTIFIER} {printf("Line: %d token IDENTIFIER: %s\n", line_num, yytext); yylval.string = yytext; return IDENTIFIER;}

{CONSTANT_STRING}		{printf("Line: %d token CONSTANT_STRING: %s\n", line_num, yytext); return CONSTANT_STRING;}
{POSITIVE_INT}			{printf("Line: %d token POSITIVE_INT: %s\n",line_num,yytext); yylval.integer = atoi(yytext);return POSITIVE_INT;}
{REAL}					{printf("Line: %d token REAL: %s\n", line_num, yytext);  return REAL;}

[+-]         			{printf("Line: %d token OP_PLUS: %s\n", line_num, yytext); return OP_ADDSUB;}
[:]                             {printf("Line: %d token OP_PLUS: %s\n", line_num, yytext); return OP_COLON;}
[?]                             {printf("Line: %d token OP_PLUS: %s\n", line_num, yytext); return OP_QUESTION;}
(\+\+|--)                             {printf("Line: %d token OP_PLUS: %s\n", line_num, yytext); return OP_INCDEC;}
[\|]                             {printf("Line: %d token OP_PLUS: %s\n", line_num, yytext); return OP_BITWISE_OR;}
[\^]                             {printf("Line: %d token OP_PLUS: %s\n", line_num, yytext); return OP_XOR;}
[&]                             {printf("Line: %d token OP_PLUS: %s\n", line_num, yytext); return OP_BITWISE_AND;}
[*]         			{printf("Line: %d token OP_MULT: %s\n", line_num, yytext); return OP_MULT; }
[/]         			{printf("Line: %d token OP_DIVIS: %s\n", line_num, yytext); return OP_DIVIS; }
[%]		{ return OP_REM; }
[=]         			{printf("Line: %d token OP_EQUAL: %s\n", line_num, yytext); return OP_EQUAL; }
[=][=]                             {printf("Line: %d token OP_EQUAL: %s\n", line_num, yytext); return OP_EQUALITY; }
([<>][=])|[<>] 			 { return OP_RELTIONAL; }
(<<|>>)				 { return OP_SHIFT;}
[!=]					{printf("Line: %d token OP_DIFFERENT: %s\n", line_num, yytext); return OP_DIFFERENT; }
[!][~]					{printf("Line: %d token NEG_REGEX_OPERATOR: %s\n", line_num, yytext); return NEG_REGEX_OPERATOR; }
[!] 					{printf("Line: %d token not: %s\n", line_num, yytext); return OP_NOT; }
[:][=]					{printf("Line: %d token OP_ASSIGNMENT: %s\n", line_num, yytext); return OP_ASSIGNMENT; }
[;]         			{printf("Line: %d token OP_SEMICOLON: %s\n", line_num, yytext); return OP_SEMICOLON; }
[(]         			{printf("Line: %d token OP_LEFT_PARENTHESIS: %s\n", line_num, yytext); return OP_LEFT_PARENTHESIS; }
[)]         			{printf("Line: %d token OP_RIGHT_PARENTHESIS: %s\n", line_num, yytext); return OP_RIGHT_PARENTHESIS; }
[~]		{ return OP_TILDE; }
[,]         			{printf("Line: %d token OP_COMMA: %s\n", line_num, yytext); return OP_COMMA; }
[[]         			{printf("Line: %d token OP_LEFT_BRACKET %s\n:", line_num, yytext); } return OP_LEFT_BRACKET;
[]]         			{printf("Line: %d token OP_RIGHT_BRACKET: %s\n", line_num, yytext); return OP_RIGHT_BRACKET; }

[{]         			{printf("Line: %d token LEFT_CURLY_BRACKET: %s\n", line_num, yytext); return LEFT_CURLY_BRACKET; }
[}]         			{printf("Line: %d token RIGHT_CURLY_BRACKET: %s\n", line_num, yytext); return RIGHT_CURLY_BRACKET; }
[=][~]					{printf("Line: %d token REGEX_OPERATOR: %s\n", line_num, yytext); return REGEX_OPERATOR; }
[.]						{printf("Line: %d token DOT_OPERATOR: %s\n", line_num, yytext); return DOT_OPERATOR; }
[$][_]					{printf("Line: %d token SPL_LIST_ARR_VAR: %s\n", line_num, yytext); return SPL_LIST_ARR_VAR; } /* Not sure how to handle this one */

{ASSIGNMENT_OPERATOR} {  return T_ASSIGN_OPER; } /* yylval.string = new std::string(yytext); */

{MULTILINECOMMENTBEGIN}					{ BEGIN(comment);} /* printf("Starting multi line commenting\n"); */ 
<comment>[^=\n]*        /* eat anything that's not a '=' */
<comment>\n             ++line_num;
<comment>^"=cut"$   {BEGIN(INITIAL);} /* printf("Comment End and begin initial code\n");*/


"#"					BEGIN(line_comment);  /* Single Line Comment */
<line_comment>[^\n]*        /* eat anything in that row */
<line_comment>\n           ++line_num;  BEGIN(INITIAL);


{WHITESPACE}*			{	/* skip whitespaces */}
\n 						{printf(">> "); ++line_num; };
<<EOF>> 				{printf("EOF detected \n"); return TK_EOF;};

.        				{printf("UNKNOWN %s", yytext); return ERROR_MESSAGE;}

%%


void yyerror(char const *s, ...) {
     fprintf (stderr, "Parse error : %s\n", s);
     // exit(1);
}
/*user code
*int main ()
*{
*
*	int token;
*	while ( (token = yylex()) != TK_EOF )
*	{	
*	if (token==303) 
*		{
*			303 is . (any other token which isn't mentioned) 
*			printf("Unrecognized token %s in line %u\n", yytext, line_num);
*			printf("EXIT\n");
*			exit(1);
*		}
*	}
*}
*/

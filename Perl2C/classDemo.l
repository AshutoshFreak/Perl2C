%{
int charcount=0, linecount=0, wordcount=0;
%}
letter [A-Za-z]
digit [0-9]
id {letter}({letter}|{digit})*
%%
{id} {wordcount++;} 
 /* charcount += yyleng;} */
. charcount++;
\n {linecount++; charcount++;}
%%
int main(){
    yylex();
    printf("There were %d words %d characters in the %d lines \n", wordcount,charcount,linecount);
    return 0;
}

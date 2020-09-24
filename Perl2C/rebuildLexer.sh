flex lexer.l
gcc -o perl2c.bin lex.yy.c -lfl
./perl2c.bin < $1
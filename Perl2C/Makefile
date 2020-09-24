parser: lexer.l parser.y
	bison -d parser.y 
	# bison -d -t parser.y 
	flex lexer.l
	gcc parser.tab.c lex.yy.c -lfl -o perl2c
clean:
	rm lex.yy.c parse praser.tab.* parser.output
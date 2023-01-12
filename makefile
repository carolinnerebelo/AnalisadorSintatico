output: lex.yy.o
	gcc -g -o output analisador-sintatico.tab.c lex.yy.o

lex.yy.o: lex.yy.c analisador-sintatico.tab.h
	gcc -g -c lex.yy.c

lex.yy.c: analisador-lexico.l analisador-sintatico.tab.h
	flex analisador-lexico.l

analisador-sintatico.tab.h analisador-sintatico.tab.c: analisador-sintatico.y
	bison -d -v analisador-sintatico.y

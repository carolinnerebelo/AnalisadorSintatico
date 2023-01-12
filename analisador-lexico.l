%{

/*
TRABALHO 2 DE LINGUAGENS FORMAIS
Caroline Bernat Rebelo - DRE 118046249
Júlio Ricardo Burlamaqui dos Santos - DRE 121125214
Lucas Cavalcante Nascimento Silva - DRE 121056863
*/

#include "analisador-sintatico.tab.h"

int cont = 0;
int linha_coment = 0;
int indent = 0;

extern FILE *file;

%}

%option yylineno
%x COMMENT
%x INDENT

%%

"//".*    fprintf(file, "<COMENTARIO, '%s', %d, %d>\n", yytext, yylineno, indent);
"/*"    { cont++; fprintf(file, "<COMENTARIO, '"); linha_coment = yylineno; BEGIN(COMMENT); }

<COMMENT>{
    "/*"        cont++;
    \n" "*      fprintf(file, "\\n ");
    .           fprintf(file, "%s", yytext);
    "*/"        cont--; if (cont == 0) { fprintf(file, "', %d, %d>\n", linha_coment, indent); BEGIN(INITIAL); }
}

\n      indent = 0;
\n" "  { indent = 0; indent++; BEGIN(INDENT); }

<INDENT>{
    " "    indent++;
    .|\n   unput(yytext[yyleng-1]); BEGIN(INITIAL);
}

    /*PALAVRAS RESERVADAS E OUTROS TOKENS*/
if      { fprintf(file, "<IF, 'if', %d, %d>\n", yylineno, indent); return IF; }
else    { fprintf(file, "<ELSE, 'else', %d, %d>\n", yylineno, indent); return ELSE; }
while   { return WHILE; fprintf(file, "<WHILE, 'while', %d, %d>\n", yylineno, indent); return WHILE; }
var     { fprintf(file, "<VAR, 'var', %d, %d>\n", yylineno, indent); return VAR; }
return  { fprintf(file, "<RETURN, 'return', %d, %d>\n", yylineno, indent); return RETURN; }
fn      { fprintf(file, "<FN, 'fn', %d, %d>\n", yylineno, indent); return FN; }
bool    { fprintf(file, "<BOOL, 'bool', %d, %d>\n", yylineno, indent); return BOOL; }
int     { fprintf(file, "<INT, 'int', %d, %d>\n", yylineno, indent); return INT; }
float   { fprintf(file, "<FLOAT, 'float', %d, %d>\n", yylineno, indent); return FLOAT; }
true    { fprintf(file, "<TRUE, 'true', %d, %d>\n", yylineno, indent); return _TRUE; }
false   { fprintf(file, "<FALSE, 'false', %d, %d>\n", yylineno, indent); return _FALSE; }
"="     { fprintf(file, "<=, '=', %d, %d>\n", yylineno, indent); return ATRIB; }
"("     { fprintf(file, "<(, '(', %d, %d>\n", yylineno, indent); return ABRE_PAR; }
")"     { fprintf(file, "<), ')', %d, %d>\n", yylineno, indent); return FECHA_PAR; }
"{"     { fprintf(file, "<{, '{', %d, %d>\n", yylineno, indent); return ABRE_CH; }
"}"     { fprintf(file, "<}, '}', %d, %d>\n", yylineno, indent); return FECHA_CH; }
";"     { fprintf(file, "<;, ';', %d, %d>\n", yylineno, indent); return TERM; }
","     { fprintf(file, "<,, ',', %d, %d>\n", yylineno, indent); return VIRG; }
":"     { fprintf(file, "<:, ':', %d, %d>\n", yylineno, indent); return DPONTOS; }

    /*IDENTIFICADORES*/
[a-zA-Z_][a-zA-Z0-9_]*  { fprintf(file, "<ID, '%s', %d, %d>\n", yytext, yylineno, indent); return ID; }

    /*NUMEROS*/
0|[1-9][0-9]*               { fprintf(file, "<INTEIRO, '%s', %d, %d>\n", yytext, yylineno, indent); return N_INT; }
0[.][0-9]+|[1-9][0-9]+[.][0-9]+|[.][1-9][0-9]* { fprintf(file, "<FLOAT, '%s', %d, %d>\n", yytext, yylineno, indent); return N_FLOAT; }

    /*OPERADORES BINÁRIOS*/
"+"     { fprintf(file, "<+, '+', %d, %d>\n", yylineno, indent); return ADD; }
"-"     { fprintf(file, "<-, '-', %d, %d>\n", yylineno, indent); return SUB; }
"=="    { fprintf(file, "<==, '==', %d, %d>\n", yylineno, indent); return IG; }
"!="    { fprintf(file, "<!=, '!=', %d, %d>\n", yylineno, indent); return DIF; }

    /*ERROS LEXICOS*/
"*/"|[0-9]+[a-zA-Z]+   fprintf(file, "<ERRO LÉXICO: '%s', %d, %d>\n", yytext, yylineno, indent);

%%


int yywrap() {
    return 1;
}


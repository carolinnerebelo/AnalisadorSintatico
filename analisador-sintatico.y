%{
#include <stdio.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;

FILE *file;

%}

%token IF ELSE WHILE VAR RETURN FN BOOL INT FLOAT _TRUE _FALSE
%token ATRIB ABRE_PAR FECHA_PAR ABRE_CH FECHA_CH TERM VIRG DPONTOS
%token ID
%token N_INT N_FLOAT
%token ADD SUB IG DIF

%start inicio

%%



inicio:
    | inicio declaracao_variavel
    | inicio declaracao_funcao
    ;

declaracao_variavel: VAR ID DPONTOS BOOL TERM  { printf("VAR ID DPONTOS BOOL TERM --> declaracao_variavel\n"); }
    | VAR ID DPONTOS INT TERM  { printf("VAR ID DPONTOS INT TERM --> declaracao_variavel\n"); }
    | VAR ID DPONTOS FLOAT TERM  { printf("VAR ID DPONTOS FLOAT TERM --> declaracao_variavel\n"); }
    | VAR ID DPONTOS BOOL ATRIB _TRUE TERM  {printf("VAR ID DPONTOS BOOL ATRIB _TRUE TERM --> declaracao_variavel\n");}
    | VAR ID DPONTOS BOOL ATRIB _FALSE TERM  {printf("VAR ID DPONTOS BOOL ATRIB _FALSE TERM --> declaracao_variavel\n");}
    | VAR ID DPONTOS INT ATRIB exp TERM  {printf("VAR ID DPONTOS INT ATRIB exp TERM --> declaracao_variavel\n");}
    | VAR ID DPONTOS FLOAT ATRIB exp TERM  {printf("VAR ID DPONTOS FLOAT ATRIB exp TERM --> declaracao_variavel\n");}
    ;

declaracao_funcao:  FN ID ABRE_PAR parametros FECHA_PAR DPONTOS INT ABRE_CH bloco FECHA_CH TERM {printf("FN ID ABRE_PAR parametros FECHA_PAR DPONTOS INT ABRE_CH bloco FECHA_CH TERM --> declaracao_funcao\n");}
    | FN ID ABRE_PAR parametros FECHA_PAR DPONTOS BOOL ABRE_CH bloco FECHA_CH TERM {printf("FN ID ABRE_PAR parametros FECHA_PAR DPONTOS BOOL ABRE_CH bloco FECHA_CH TERM --> declaracao_funcao\n");}
    | FN ID ABRE_PAR parametros FECHA_PAR DPONTOS FLOAT ABRE_CH bloco FECHA_CH TERM {printf("FN ID ABRE_PAR parametros FECHA_PAR DPONTOS FLOAT ABRE_CH bloco FECHA_CH TERM --> declaracao_funcao\n");}


exp: num { printf("num --> exp\n"); }
    | exp ADD num { printf("exp ADD num --> exp\n"); }
    | exp SUB num { printf("exp SUB num --> exp\n"); }
    ;

num: N_FLOAT { printf("N_FLOAT --> num\n"); }
    | N_INT { printf("N_INT --> num\n"); }
    ;


parametros: { printf("Vazio --> parametros\n") }
    | ID INT VIRG parametros { printf("ID INT VIRG parametros --> parametros\n"); }
    | ID INT { printf("ID INT --> parametros\n"); }
    | ID BOOL VIRG parametros { printf("ID BOOL VIRG parametros --> parametros\n"); }
    | ID BOOL { printf("ID BOOL --> parametros\n"); }
    | ID FLOAT VIRG parametros { printf("ID FLOAT VIRG parametros --> parametros\n"); }
    | ID FLOAT { printf("ID FLOAT --> parametros\n"); }
    ;

bloco: { printf("Vazio --> bloco\n"); }
    | declaracao_variavel bloco { printf("declaracao_variavel bloco --> bloco\n"); }
    | comando bloco { printf("comando bloco --> bloco\n"); }
    ;

comando: ID ATRIB exp TERM { printf("ID ATRIB exp TERM --> comando\n"); }
    | ID ATRIB ID TERM { printf("ID ATRIB ID TERM --> comando\n"); }
    | IF ABRE_PAR condicao FECHA_PAR ABRE_CH comando FECHA_CH TERM { printf("IF ABRE_PAR condicao FECHA_PAR ABRE_CH comando FECHA_CH TERM --> comando\n"); }
    | IF ABRE_PAR condicao FECHA_PAR ABRE_CH comando FECHA_CH ELSE ABRE_CH comando FECHA_CH TERM { printf("IF ABRE_PAR condicao FECHA_PAR ABRE_CH comando FECHA_CH ELSE ABRE_CH comando FECHA_CH TERM --> comando\n"); }
    | WHILE ABRE_PAR condicao FECHA_PAR ABRE_CH comando FECHA_CH TERM { printf("WHILE ABRE_PAR condicao FECHA_PAR ABRE_CH comando FECHA_CH TERM --> comando\n"); }
    | RETURN exp TERM { printf("RETURN exp TERM --> comando\n"); }
    | RETURN ID TERM { printf("RETURN ID TERM --> comando\n"); }
    
    ;

condicao: ID { printf("ID --> condicao\n"); }
    | ID IG ID { printf("ID IG ID --> condicao\n"); }
    | ID IG num { printf("ID IG num --> condicao\n"); }
    | ID DIF ID { printf("ID DIF ID --> condicao\n"); }
    | ID DIF num { printf("ID DIF num --> condicao\n"); }
    ;


%%

int main(int argc, char **argv) {

    file = fopen(argv[2], "w");
    yyin = fopen(argv[1], "r");
    
    yyparse();

    fclose(file);
    return 0;
}

yyerror(char *s) {
  fprintf(stderr, "error: %s\n", s);
}

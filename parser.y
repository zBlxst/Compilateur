%locations

%{
    
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror();
    
/* 
Data structures    
*/

typedef struct iexpr {
    int type; // IDENT, PLUS, MINUS, STAR, DIV, INT
    char *name; 
    struct iexpr *left;
    struct iexpr *right;
    int value;
} iexpr;

typedef struct prgm {
    struct iexpr *i;
} prgm;

///////////////////////////////////////////////////////////////////

prgm *program;

/*
Functions to instanciate data structures
*/

iexpr* make_iexpr (int type, char *name, iexpr *left, iexpr *right, int value) {
    iexpr *i = malloc(sizeof(iexpr));
    i->type = type;
    i->name = name;
    i->left = left;
    i->right = right;
    i->value = value;
    return i;
}

prgm* make_prgm (iexpr *i) {
    prgm *p = malloc(sizeof(prgm));
    p->i = i;
    return p;
}




%}
///////////////////////////////////////////////////////////////////

%union {
    char *s;
    int n;
    iexpr *i;

    prgm *p;

    // ...
}

%type <i> iexpr // Des trucs à mettre mais il faut comprendre avant de faire sinon on va pas comprendre
%type <p> prgm


%token VAR IF THEN ELSE ASSIGN EQ NEQ LE LT GE GT OR AND NOT PLUS STAR MINUS DIV FUNC
%token <n> INT
%token <s> IDENT

%left ';'
%left ','

%left OR AND PLUS MINUS
%left STAR DIV

%right NOT

%%

prgm : iexpr                                { program = make_prgm($1);                     }

iexpr : IDENT                               { $$ = make_iexpr(IDENT, $1, NULL, NULL, 0);   }
    | iexpr PLUS iexpr                      { $$ = make_iexpr(PLUS, NULL, $1, $3, 0);      }
    | iexpr MINUS iexpr                     { $$ = make_iexpr(MINUS, NULL, $1, $3, 0);     }
    | iexpr STAR iexpr                      { $$ = make_iexpr(STAR, NULL, $1, $3, 0);      }
    | iexpr DIV iexpr                       { $$ = make_iexpr(DIV, NULL, $1, $3, 0);       }
    | INT                                   { $$ = make_iexpr(INT, NULL, NULL, NULL, $1);  }



%%

#include "lexer.c"

void yyerror(char *s)
{
	fflush(stdout);
	fprintf(stderr, "Erreur ligne %d %s\n", yylineno, s);
}

void print_prgm (prgm *p) {
    printf("%d\n", p->i->left->value);
}




///////////////////////////////////////////////////////////

int main(int argc, char **argv) {
    if (argc <= 1) { yyerror("no file specified"); exit(1); }
	yyin = fopen(argv[1],"r");
	if (!yyparse()) {
		print_prgm(program);
	}
	return 0;
}




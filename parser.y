%locations

%{
    
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef TYPES_INCLUDED
#include "types.c"
#endif


int yylex();
void yyerror();
    
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

sexpr* make_sexpr(int type, char *name, sexpr *left, sexpr *right, char *value) {
    sexpr *s = malloc(sizeof(sexpr));
    s->type = type;
    s->name = name;
    s->left = left;
    s->right = right;
    s->value = value;
    return s;
}

prgm* make_prgm (sexpr *s) {
    prgm *p = malloc(sizeof(prgm));
    p->s = s;
    return p;
}

decl* make_decl(char *name, char *type, expr *e){
    decl *d = malloc(sizeof(decl));
    d->name = name;
    d->type = type;
    d->init = e;
    return d;
}

expr* make_expr(iexpr *i) {
    expr *e = malloc(sizeof(expr));
    e->i = i;
    return e;
}




%}
///////////////////////////////////////////////////////////////////

%union {
    char *s;
    char *str;
    int n;
    iexpr *i;
    sexpr *se;
    expr *e;
    prgm *p;
    decl *d;
    // ...
}

%type <i> iexpr // Des trucs à mettre mais il faut comprendre avant de faire sinon on va pas comprendre
%type <p> prgm
%type <d> decl;
%type <e> expr;
%type <se> sexpr;

%token VAR IF THEN ELSE ASSIGN EQ NEQ LE LT GE GT DOUBLEPOINT OR AND NOT PLUS STAR MINUS DIV FUNC
%token <n> INT
%token <s> IDENT
%token <str> STRING

%left ';'
%left ','

%left OR AND PLUS MINUS
%left STAR DIV

%right NOT

%%

prgm : sexpr                                { program = make_prgm($1);                     }

decl : VAR IDENT DOUBLEPOINT IDENT ASSIGN expr { $$ = make_decl($2,$4,$6);}

expr : iexpr                                { $$ = make_expr($1); }

iexpr : IDENT                               { $$ = make_iexpr(IDENT, $1, NULL, NULL, 0);   }
    | iexpr PLUS iexpr                      { $$ = make_iexpr(PLUS, NULL, $1, $3, 0);      }
    | iexpr MINUS iexpr                     { $$ = make_iexpr(MINUS, NULL, $1, $3, 0);     }
    | iexpr STAR iexpr                      { $$ = make_iexpr(STAR, NULL, $1, $3, 0);      }
    | iexpr DIV iexpr                       { $$ = make_iexpr(DIV, NULL, $1, $3, 0);       }
    | INT                                   { $$ = make_iexpr(INT, NULL, NULL, NULL, $1);  }

sexpr : IDENT
    | sexpr PLUS sexpr 						{ $$ = make_sexpr(IDENT, $1, NULL, NULL, 0);}
    | STRING                                { $$ = make_sexpr(STRING, NULL, NULL, NULL, $1);  }

%%


#include "printer.c"
#include "lexer.c"

void yyerror(char *s)
{
	fflush(stdout);
	fprintf(stderr, "Erreur ligne %d %s\n", yylineno, s);
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




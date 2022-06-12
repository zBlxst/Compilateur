%locations

%{
    
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "types.c"


int yylex();
void yyerror();
    
///////////////////////////////////////////////////////////////////

prgm *program;

/*
Functions to instanciate data structures
*/

iexpr* make_iexpr (int type, iexpr *left, iexpr *right, int value) {
    iexpr *i = malloc(sizeof(iexpr));
    i->type = type;
    i->left = left;
    i->right = right;
    i->value = value;
    return i;
}

sexpr* make_sexpr(int type, sexpr *left, sexpr *right, char *value) {
    sexpr *s = malloc(sizeof(sexpr));
    s->type = type;
    s->left = left;
    s->right = right;
    s->value = value;
    return s;
}

prgm* make_prgm (block *bl) {
    prgm *p = malloc(sizeof(prgm));
    p->bl = bl;
    return p;
}

decl* make_decl(char *name, char *type, expr *e){
    decl *d = malloc(sizeof(decl));
    d->name = name;
    d->type = type;
    d->init = e;
    return d;
}

expr* make_expr(int type, var *v, iexpr *i, sexpr *s) {
    expr *e = malloc(sizeof(expr));
    e->type = type;
    e->v = v;
    e->i = i;
    e->s = s;
    return e;
}

block* make_block(int type, instrlist *insli) {
    block *b = malloc(sizeof(block));
    b->type = type;
    b->insli = insli;
    return b;
}

var* make_var(char *name) {
    var *v = malloc(sizeof(var));
    v->name = name;
    return v;
}

lvalue* make_lvalue(int type, var *v) {
    lvalue *l = malloc(sizeof(lvalue));
    l->type = type;
    l->v = v;
    return l;
}

instr* make_instr(int type, lvalue *l, expr *e, decl *d, block *bl) {
    instr *ins = malloc(sizeof(instr));
    ins->type = type;
    ins->lval = l;
    ins->e = e;
    ins->d = d;
    ins->bl = bl;
    return ins;
}

instrlist* make_instrlist(instr *ins, instrlist *next) {
    instrlist *insli = malloc(sizeof(instrlist));
    insli->ins = ins;
    insli->next = next;
    return insli;
}




%}
///////////////////////////////////////////////////////////////////

%union {
    char *s;
    char *str;
    int n;
    iexpr *i;
    expr *e;
    prgm *p;
    decl *d;
    var *v;
    lvalue *lval;
    instr *ins;
    instrlist *insli;
    sexpr *se;
    block *bl;


    // ...
}

%type <i> iexpr // Des trucs à mettre mais il faut comprendre avant de faire sinon on va pas comprendre
%type <p> prgm
%type <d> decl
%type <e> expr
%type <v> var
%type <lval> lvalue
%type <ins> instr
%type <insli> instrlist
%type <se> sexpr
%type <bl> block


%token IEXPR SEXPR DECL INSTR BLOCK // Pour faire des constantes de préprocesseur pour les int type
%token VAR IF THEN ELSE ASSIGN EQ NEQ LE LT GE GT LPARENT RPARENT LBRACK RBRACK DOUBLEPOINT OR AND NOT PLUS STAR MINUS DIV FUNC SEMICOLON SKIP
%token <n> INT
%token <s> IDENT
%token <str> STRING

%left ';'
%left ','

%left OR AND PLUS MINUS
%left STAR DIV

%right NOT

%%

prgm : block                                 { program = make_prgm($1);                    }

decl : VAR IDENT DOUBLEPOINT IDENT ASSIGN expr { $$ = make_decl($2,$4,$6);                 }

instrlist :                                    { instr *skip = make_instr(SKIP, NULL, NULL, NULL, NULL); $$ = make_instrlist(skip, NULL); }
    | instr instrlist                      { $$ = make_instrlist($1, $2);                 }

instr : block                               { $$ = make_instr(BLOCK, NULL, NULL, NULL, $1); }
    | lvalue ASSIGN expr SEMICOLON          { $$ = make_instr(ASSIGN, $1, $3, NULL, NULL);             }
    | decl SEMICOLON                        { $$ = make_instr(DECL, NULL, NULL, $1, NULL);      }

lvalue : var                                { $$ = make_lvalue(VAR, $1);                  }

var : IDENT                                 { $$ = make_var($1);                           }

block : LBRACK instrlist RBRACK             { $$ = make_block(INSTR, $2);            }

expr : var                                  { $$ = make_expr(VAR, $1, NULL, NULL);               }
    | iexpr                                 { $$ = make_expr(IEXPR, NULL, $1, NULL);               }
    | sexpr                                 { $$ = make_expr(SEXPR, NULL, NULL, $1);             }

iexpr : iexpr PLUS iexpr                    { $$ = make_iexpr(PLUS, $1, $3, 0);      }
    | iexpr MINUS iexpr                     { $$ = make_iexpr(MINUS, $1, $3, 0);     }
    | iexpr STAR iexpr                      { $$ = make_iexpr(STAR, $1, $3, 0);      }
    | iexpr DIV iexpr                       { $$ = make_iexpr(DIV, $1, $3, 0);       }
    | LPARENT iexpr RPARENT                 { $$ = make_iexpr(LPARENT, $2, NULL, 0); }
    | INT                                   { $$ = make_iexpr(INT, NULL, NULL, $1);  }

sexpr : sexpr PLUS sexpr 					{ $$ = make_sexpr(PLUS, $1, $3, 0); }
    | STRING                                { $$ = make_sexpr(STRING, NULL, NULL, $1);  }



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
    if (argc <= 1) { 
        yyerror("no file specified"); exit(1);
    }

	yyin = fopen(argv[1],"r");
	if (!yyparse()) {
		printf("\n");
        print_prgm(program);
        printf("\n");
	}
	return 0;
}




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

prgm* make_prgm (instr *i) {
    prgm *p = malloc(sizeof(prgm));
    p->ins = i;
    return p;
}

decl* make_decl(char *name, char *type, expr *e){
    decl *d = malloc(sizeof(decl));
    d->name = name;
    d->type = type;
    d->init = e;
    return d;
}

expr* make_expr(int type, var *v, int intValue, char *stringValue, int boolValue, expr *left, expr *right) {
    expr *e = malloc(sizeof(expr));
    e->type = type;
    e->v = v;
    e->intValue = intValue;
    e->stringValue = stringValue;
    e->boolValue = boolValue;
    e->left = left;
    e->right = right;
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

assign* make_assign(lvalue *lval, expr *e) {
    assign *a = malloc(sizeof(assign));
    a->lval = lval;
    a->e = e;
    return a;
}

instr* make_instr(int type, assign *a, decl *d, block *bl, forloop *fl) {
    instr *ins = malloc(sizeof(instr));
    ins->type = type;
    ins->a = a;
    ins->d = d;
    ins->bl = bl;
    ins->fl = fl;
    return ins;
}

instrlist* make_instrlist(instr *ins, instrlist *next) {
    instrlist *insli = malloc(sizeof(instrlist));
    insli->ins = ins;
    insli->next = next;
    return insli;
}

forloop* make_forloop(instr *init, expr *cond, instr *end, instr *ins){
    printf("for loop\n");
    forloop *fl = malloc(sizeof(forloop));
    fl->init = init;
    fl->cond = cond;
    fl->end = end;
    fl->ins = ins;
    return fl;
}




%}
///////////////////////////////////////////////////////////////////

%union {
    char *s;
    char *str;
    int n;
    expr *e;
    prgm *p;
    decl *d;
    var *v;
    lvalue *lval;
    instr *ins;
    instrlist *insli;
    block *bl;
    forloop *fl;
    assign *a;


    // ...
}

// Des trucs à mettre mais il faut comprendre avant de faire sinon on va pas comprendre
%type <p> prgm
%type <d> decl
%type <e> expr
%type <v> var
%type <lval> lvalue
%type <ins> instr
%type <insli> instrlist
%type <bl> block
%type <fl> forloop
%type <a> assign

%token DECL INSTR BLOCK BOOL PARENTH // Pour faire des constantes de préprocesseur pour les int type
%token VAR IF THEN ELSE ASSIGN EQ NEQ LE LT GE GT LPARENT RPARENT LBRACK RBRACK DOUBLEPOINT OR AND NOT PLUS STAR MINUS DIV FUNC FOR SEMICOLON SKIP
%token <n> INT
%token <s> IDENT
%token <str> STRING

%left ';'
%left ','

%left OR AND PLUS MINUS
%left STAR DIV

%right NOT

%%

prgm : instr                                 { program = make_prgm($1);                    }

decl : VAR IDENT DOUBLEPOINT IDENT ASSIGN expr { $$ = make_decl($2,$4,$6);                 }

instrlist :                                    { instr *skip = make_instr(SKIP, NULL, NULL, NULL, NULL); $$ = make_instrlist(skip, NULL); }
    | forloop instrlist                     {instr *ins = make_instr(FOR, NULL, NULL, NULL, $1); $$ = make_instrlist(ins, $2); }
    | instr SEMICOLON instrlist                      { $$ = make_instrlist($1, $3);                 }

instr : block                               { $$ = make_instr(BLOCK, NULL, NULL, $1,NULL); }
    | assign                                { $$ = make_instr(ASSIGN, $1, NULL, NULL,NULL);             }
    | decl                                  { $$ = make_instr(DECL, NULL, $1, NULL, NULL);      }
    | forloop                               { $$ = make_instr(FOR, NULL, NULL, NULL, $1);}

assign :  lvalue ASSIGN expr                { $$ = make_assign($1, $3); }

lvalue : var                                { $$ = make_lvalue(VAR, $1);                  }

var : IDENT                                 { $$ = make_var($1);                           }

block : LBRACK instrlist RBRACK             { $$ = make_block(INSTR, $2);            }

expr : var                                  { $$ = make_expr(VAR, $1, 0, NULL, 0, NULL, NULL);               }
    | INT                                   { $$ = make_expr(INT, NULL, $1, NULL, 0, NULL, NULL);               }
    | STRING                                { $$ = make_expr(STRING, NULL, 0, $1, 0, NULL, NULL);             } 
    | expr PLUS expr                        { $$ = make_expr(PLUS, NULL, 0, NULL, 0, $1, $3);      }
    | expr MINUS expr                       { $$ = make_expr(MINUS, NULL, 0, NULL, 0, $1, $3);     }
    | expr STAR expr                        { $$ = make_expr(STAR, NULL, 0, NULL, 0, $1, $3);      }
    | expr DIV expr                         { $$ = make_expr(DIV, NULL, 0, NULL, 0, $1, $3);       }
    | LPARENT expr RPARENT                  { $$ = make_expr(PARENTH, NULL, 0, NULL, 0, $2, NULL); }


forloop : FOR LPARENT instr SEMICOLON expr SEMICOLON instr RPARENT instr { $$ = make_forloop($3,$5,$7,$9); }



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

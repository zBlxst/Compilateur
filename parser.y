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

prgm* make_prgm (class *cl) {
    prgm *p = malloc(sizeof(prgm));
    p->cl = cl;
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

instr* make_instr(int type, assign *a, decl *d, block *bl, forloop *fl, whileloop *wl, ifinstr *ifins) {
    instr *ins = malloc(sizeof(instr));
    ins->type = type;
    ins->a = a;
    ins->d = d;
    ins->bl = bl;
    ins->fl = fl;
    ins->wl = wl;
    ins->ifins = ifins;
    return ins;
}

instrlist* make_instrlist(instr *ins, instrlist *next) {
    instrlist *insli = malloc(sizeof(instrlist));
    insli->ins = ins;
    insli->next = next;
    return insli;
}

forloop* make_forloop(instr *init, expr *cond, instr *end, instr *ins){
    forloop *fl = malloc(sizeof(forloop));
    fl->init = init;
    fl->cond = cond;
    fl->end = end;
    fl->ins = ins;
    return fl;
}

whileloop* make_whileloop(expr *cond, instr *ins) {
    whileloop *wl = malloc(sizeof(whileloop));
    wl->cond = cond;
    wl->ins = ins;
    return wl;
}

ifinstr* make_ifinstr(expr *cond, instr *yes, instr *no) {
    ifinstr *ifins = malloc(sizeof(ifinstr));
    ifins->cond = cond;
    ifins->yes = yes;
    ifins->no = no;
    return ifins;
}

arg* make_arg(char *name, char *type) {
    arg *a = malloc(sizeof(arg));
    a->name = name;
    a->type = type;
    return a;
}

arglist* make_arglist(arg *a, arglist *next) {
    arglist *argl = malloc(sizeof(arglist));
    argl->a = a;
    argl->next = next;
    return argl;
}

function* make_function(char *name, arglist *argli, char *type, instr *ins) {
    function *f = malloc(sizeof(function));
    f->name = name;
    f->args = argli;
    f->type = type;
    f->ins = ins;
    return f;
}

attrib* make_attrib(char *name, char *type) {
    attrib *att = malloc(sizeof(attrib));
    att->name = name;
    att->type = type;
    return att;
}

method* make_method(char *name, arglist *argli, char *type, instr *ins) {
    method *meth = malloc(sizeof(method));
    meth->name = name;
    meth->args = argli;
    meth->type = type;
    meth->ins = ins;
    return meth;
}

attribormethod* make_attribormethod(int type, attrib *att, method *meth) {
    attribormethod *aorm = malloc(sizeof(attribormethod));
    aorm->type = type;
    aorm->att = att;
    aorm->meth = meth;
    return aorm;
}

attribormethodlist* make_attribormethodlist(attribormethod *aorm, attribormethodlist *next) {
    attribormethodlist *aormlist = malloc(sizeof(attribormethodlist));
    aormlist->aorm = aorm;
    aormlist->next = next;
    return aormlist;
}

class* make_class(char *name, attribormethodlist *aormli) {
    class *cl = malloc(sizeof(class));
    cl->name = name;
    cl->aormli = aormli;
    return cl;
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
    whileloop *wl;
    ifinstr *ifins;
    assign *a;

    arg *ar;
    arglist *arli;
    function *f;

    attrib *att;
    method *meth;
    attribormethod *aorm;
    attribormethodlist *aormli;
    class *cl;


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
%type <wl> whileloop
%type <a> assign
%type <ifins> ifinstr

%type <ar> arg
%type <arli> arglist
%type <f> function

%type <att> attrib
%type <meth> method
%type <aorm> attribormethod
%type <aormli> attribormethodlist
%type <cl> class


%token DECL INSTR BLOCK BOOL PARENTH METHOD ATTRIB CLASS
%token VAR IF THEN ELSE ASSIGN EQ NEQ LE LT GE GT LPARENT RPARENT LBRACK RBRACK DOUBLEPOINT OR AND NOT PLUS STAR MINUS DIV FUNC FOR WHILE SEMICOLON SKIP COMMA
%token <n> INT
%token <s> IDENT
%token <str> STRING

%left ';'
%left ','

%left OR AND PLUS MINUS
%left STAR DIV

%right NOT

%%

prgm : class                                 { program = make_prgm($1);                    }



lvalue : var                                { $$ = make_lvalue(VAR, $1);                  }
var : IDENT                                 { $$ = make_var($1);                           }


attrib : VAR IDENT DOUBLEPOINT IDENT SEMICOLON    { $$ = make_attrib($2, $4); }
method : FUNC IDENT LPARENT arglist RPARENT DOUBLEPOINT IDENT instr { $$ = make_method($2, $4, $7, $8);}
    | FUNC IDENT DOUBLEPOINT IDENT instr { $$ = make_method($2, NULL, $4, $5);}
attribormethod : attrib                 { $$ = make_attribormethod(ATTRIB, $1, NULL); }
    | method                            { $$ = make_attribormethod(METHOD, NULL, $1); }

attribormethodlist : attribormethod       { $$ = make_attribormethodlist($1, NULL); }
    | attribormethod attribormethodlist   { $$ = make_attribormethodlist($1, $2); }

class : CLASS IDENT LBRACK attribormethodlist RBRACK { $$ = make_class($2, $4); }


arg : IDENT DOUBLEPOINT IDENT               { $$ = make_arg($1, $3); }
arglist :                               { $$ = NULL;} 
    | arg                               { $$ = make_arglist($1, NULL);}
    | arg COMMA arglist                 { $$ = make_arglist($1, $3); }
function : FUNC IDENT LPARENT arglist RPARENT DOUBLEPOINT IDENT instr { $$ = make_function($2, $4, $7, $8);}
    | FUNC IDENT DOUBLEPOINT IDENT instr { $$ = make_function($2, NULL, $4, $5);}

expr : var                                  { $$ = make_expr(VAR, $1, 0, NULL, 0, NULL, NULL);               }
    | INT                                   { $$ = make_expr(INT, NULL, $1, NULL, 0, NULL, NULL);               }
    | STRING                                { $$ = make_expr(STRING, NULL, 0, $1, 0, NULL, NULL);             } 
    | expr PLUS expr                        { $$ = make_expr(PLUS, NULL, 0, NULL, 0, $1, $3);      }
    | expr MINUS expr                       { $$ = make_expr(MINUS, NULL, 0, NULL, 0, $1, $3);     }
    | expr STAR expr                        { $$ = make_expr(STAR, NULL, 0, NULL, 0, $1, $3);      }
    | expr DIV expr                         { $$ = make_expr(DIV, NULL, 0, NULL, 0, $1, $3);       }
    | expr LE expr                          { $$ = make_expr(LE, NULL, 0, NULL, 0, $1, $3);        }
    | expr LT expr                          { $$ = make_expr(LT, NULL, 0, NULL, 0, $1, $3);        }
    | expr GT expr                          { $$ = make_expr(GT, NULL, 0, NULL, 0, $1, $3);        }
    | expr GE expr                          { $$ = make_expr(GE, NULL, 0, NULL, 0, $1, $3);        }
    | expr EQ expr                          { $$ = make_expr(EQ, NULL, 0, NULL, 0, $1, $3);        }
    | expr NEQ expr                         { $$ = make_expr(NEQ, NULL, 0, NULL, 0, $1, $3);       }
    | expr OR expr                          { $$ = make_expr(OR, NULL, 0, NULL, 0, $1, $3);        }
    | expr AND expr                         { $$ = make_expr(AND, NULL, 0, NULL, 0, $1, $3);       }    
    | NOT expr                              { $$ = make_expr(NOT, NULL, 0, NULL, 0, $2, NULL);     }        
    | LPARENT expr RPARENT                  { $$ = make_expr(PARENTH, NULL, 0, NULL, 0, $2, NULL); }

instrlist : forloop instrlist                     {instr *ins = make_instr(FOR, NULL, NULL, NULL, $1, NULL, NULL); $$ = make_instrlist(ins, $2); }
    | whileloop instrlist                   {instr *ins = make_instr(WHILE, NULL, NULL, NULL, NULL, $1, NULL); $$ = make_instrlist(ins, $2); }
    | ifinstr instrlist                     {instr *ins = make_instr(IF, NULL, NULL, NULL, NULL, NULL, $1); $$ = make_instrlist(ins, $2); }
    | instr SEMICOLON instrlist                      { $$ = make_instrlist($1, $3);                 }
    |                                       { instr *skip = make_instr(SKIP, NULL, NULL, NULL, NULL, NULL, NULL); $$ = make_instrlist(skip, NULL); }

instr : block                               { $$ = make_instr(BLOCK, NULL, NULL, $1,NULL, NULL, NULL); }
    | assign                                { $$ = make_instr(ASSIGN, $1, NULL, NULL,NULL, NULL, NULL);             }
    | decl                                  { $$ = make_instr(DECL, NULL, $1, NULL, NULL, NULL, NULL);      }
    | forloop                               { $$ = make_instr(FOR, NULL, NULL, NULL, $1, NULL, NULL);}
    | whileloop                             { $$ = make_instr(WHILE, NULL, NULL, NULL, NULL, $1, NULL);}
    | ifinstr                               { $$ = make_instr(IF, NULL, NULL, NULL, NULL, NULL, $1); }


assign :  lvalue ASSIGN expr                { $$ = make_assign($1, $3); }
decl : VAR IDENT DOUBLEPOINT IDENT ASSIGN expr { $$ = make_decl($2,$4,$6);                 }
block : LBRACK instrlist RBRACK             { $$ = make_block(INSTR, $2);            }
whileloop : WHILE LPARENT expr RPARENT instr { $$ = make_whileloop($3, $5); }
forloop : FOR LPARENT instr SEMICOLON expr SEMICOLON instr RPARENT instr { $$ = make_forloop($3,$5,$7,$9); }
ifinstr : IF LPARENT expr RPARENT instr ELSE instr { $$ = make_ifinstr($3, $5, $7); }
    | IF LPARENT expr RPARENT instr         { $$ = make_ifinstr($3, $5, NULL); }



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

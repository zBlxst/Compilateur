#ifndef PRINTER_INCLUDED
#define PRINTER_INCLUDED
#include "types.c"

void print_prgm(prgm *p);
void print_decl(decl *d);
void print_expr(expr *e);
void print_var(var *v);
void print_instr(instr *ins);
void print_instrlist(instrlist *insli);
void print_lvalue(lvalue *lval);
void print_iexpr(iexpr *i); 
void print_sexpr(sexpr *s);

void print_prgm(prgm *p) {
    print_instrlist(p->insli);
}

void print_decl(decl *d) {
    printf("var %s : %s = ", d->name, d->type);
    print_expr(d->init);
}

void print_expr(expr *e) {
    switch (e->type)
    {
    case VAR:
        print_var(e->v);
        break;
    case IEXPR:
        print_iexpr(e->i);
        break;
    case SEXPR:
        print_sexpr(e->s);
        break;
    }
}

void print_var(var *v) {
    printf("%s", v->name);
}

void print_instr(instr *ins) {
    switch (ins->type) {
        case ASSIGN:
            print_lvalue(ins->lval);
            printf(" = ");
            print_expr(ins->e);
            printf(";\n");
            break;
        case DECL:
            print_decl(ins->d);
            printf(";\n");
        case SKIP:
            break;
    }
}

void print_instrlist(instrlist *insli) {
    print_instr(insli->ins);
    if (insli->next != NULL) {
        print_instrlist(insli->next);
    }
}

void print_lvalue(lvalue *lval) {
    switch (lval->type)
    {
    case VAR:
        print_var(lval->v);
        break;
    }
}



void print_iexpr(iexpr *i) {
    switch (i->type) {
        case PLUS:
            print_iexpr(i->left);
            printf(" + ");
            print_iexpr(i->right);
            break;
        case MINUS:
            print_iexpr(i->left);
            printf(" - ");
            print_iexpr(i->right);
            break;
        case STAR:
            print_iexpr(i->left);
            printf(" * ");
            print_iexpr(i->right);
            break;
        case DIV:
            print_iexpr(i->left);
            printf(" / ");
            print_iexpr(i->right);
            break;
        case INT:
            printf("%d", i->value);
            break;
        case LPARENT:
            printf("(");
            print_iexpr(i->left);
            printf(")");
            break;
        
    } 
}

void print_sexpr(sexpr *s) {
    switch (s->type)
    {
    case PLUS:
        print_sexpr(s->left);
        printf(" + ");
        print_sexpr(s->right);
        break;
    
    case STRING:
        printf("%s", s->value);
    }
}



#endif


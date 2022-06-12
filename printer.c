#include "types.c"
#ifndef PRINTER_INCLUDED
#define PRINTER_INCLUDED

void print_prgm(prgm *p);
void print_decl(decl *d);
void print_iexpr(iexpr *i); 
void print_expr(expr *e);

void print_prgm(prgm *p) {
    print_sexpr(p->s);
}

void print_decl(decl *d) {
    printf("var %s : %s = ", d->name, d->type);
    print_expr(d->init);
}

void print_expr(expr *e) {
    print_iexpr(e->i);
}

void print_sexpr(sexpr *s) {
    printf("var %s : %s = ", s->name);
}

void print_iexpr(iexpr *i) {
    switch (i->type) {
        case IDENT:
            printf("%s", i->name);
            break;
        case PLUS:
            print_iexpr(i->left);
            printf("+");
            print_iexpr(i->right);
            break;
        case MINUS:
            print_iexpr(i->left);
            printf("-");
            print_iexpr(i->right);
            break;
        case STAR:
            print_iexpr(i->left);
            printf("*");
            print_iexpr(i->right);
            break;
        case DIV:
            print_iexpr(i->left);
            printf("/");
            print_iexpr(i->right);
            break;
        case INT:
            printf("%d", i->value);
            break;
        
    } 
}



#endif


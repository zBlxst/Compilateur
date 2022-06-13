#ifndef PRINTER_INCLUDED
#define PRINTER_INCLUDED
#include "types.c"

void print_indent(int indent);

void print_prgm(prgm *p);
void print_block(block *bl, int indent);
void print_decl(decl *d);
void print_expr(expr *e);
void print_var(var *v);
void print_instr(instr *ins, int indent, int isInsStruct);
void print_instrlist(instrlist *insli, int indent);
void print_lvalue(lvalue *lval);
void print_forloop(forloop *lf, int indent);
void print_assign(assign *a);
void print_whileloop(whileloop *wl, int indent);

void print_indent(int indent) {
    for (int i = 0; i < indent; i++) printf("\t");
}


void print_prgm(prgm *p) {
    print_instr(p->ins, 0, 0);
}

void print_block(block *bl, int indent) {
    switch (bl->type) {
        case INSTR:
            print_indent(indent);
            printf("{\n");
            print_instrlist(bl->insli, indent+1);
            print_indent(indent);
            printf("}\n");
            break;
    }
}

void print_forloop(forloop *lf, int indent){
    print_indent(indent);
    printf("for(");
    print_instr(lf->init, 0, 1);
    printf("; ");
    print_expr(lf->cond);
    printf("; ");
    print_instr(lf->end, 0, 1);
    printf(")\n");
    print_instr(lf->ins, indent, 0);
}

void print_whileloop(whileloop *wl, int indent) {
    print_indent(indent);
    printf("while(");
    print_expr(wl->cond);
    printf(")\n");
    print_instr(wl->ins, indent, 0);
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
        case INT:
            printf("%d", e->intValue);
            break;
        case STRING:
            printf("%s", e->stringValue);
            break;
        case BOOL:
            printf("%s", e->boolValue ? "true" : "false");
        case PLUS:
            print_expr(e->left);
            printf(" + ");
            print_expr(e->right);
            break;
        case MINUS:
            print_expr(e->left);
            printf(" - ");
            print_expr(e->right);
            break;
        case STAR:
            print_expr(e->left);
            printf(" * ");
            print_expr(e->right);
            break;
        case DIV:
            print_expr(e->left);
            printf(" / ");
            print_expr(e->right);
            break;
        case PARENTH:
            printf("(");
            print_expr(e->left);
            printf(")");
            break;
    }
}

void print_var(var *v) {
    printf("%s", v->name);
}

void print_assign(assign *a) {
    print_lvalue(a->lval);
    printf(" = ");
    print_expr(a->e);
}

void print_instr(instr *ins, int indent, int isInStruct) {
    switch (ins->type) {
        case ASSIGN:
            print_indent(indent);
            print_assign(ins->a);
            if (!isInStruct) {
                printf(";\n");
            }
            break;
        case DECL:
            print_indent(indent);
            print_decl(ins->d);
            if (!isInStruct) {
                printf(";\n");
            }
            break;
        case BLOCK:
            print_block(ins->bl, indent);
            break;
        case FOR:
            print_forloop(ins->fl, indent);
            break;
        case WHILE:
            print_whileloop(ins->wl, indent);
        case SKIP:
            break;
    }
}

void print_instrlist(instrlist *insli, int indent) {
    print_instr(insli->ins, indent, 0);
    if (insli->next != NULL) {
        print_instrlist(insli->next, indent);
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

#endif

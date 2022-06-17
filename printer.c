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
void print_ifinstr(ifinstr *ifins, int indent);

void print_arg(arg *a);
void print_arglist(arglist *argli);
void print_function(function *f);

void print_attrib(attrib *att);
void print_method(method *meth);
void print_attribormethod(attribormethod *aorm);
void print_attribormethodlist(attribormethodlist *aormli);
void print_class(class *cl);

void print_indent(int indent) {
    for (int i = 0; i < indent; i++) printf("\t");
}


void print_prgm(prgm *p) {
    print_class(p->cl);
}

void print_attrib(attrib *att) {
    printf("\tvar %s : %s;", att->name, att->type);
}

void print_method(method *meth) {
    printf("\tfunc %s(", meth->name);
    if (meth->args != NULL) {
        print_arglist(meth->args);
    }
    printf(") : %s\n", meth->type);
    print_instr(meth->ins, 1, 0);    
}

void print_attribormethod(attribormethod *aorm) {
    switch (aorm->type)
    {
    case ATTRIB:
        print_attrib(aorm->att);
        break;
    case METHOD:
        print_method(aorm->meth);
        break;
    }
}

void print_attribormethodlist(attribormethodlist *aormli) {
    print_attribormethod(aormli->aorm);
    printf("\n");
    if (aormli->next != NULL) {
        print_attribormethodlist(aormli->next);
    }
}

void print_class(class *cl) {
    printf("class %s\n{\n", cl->name);
    if (cl->aormli != NULL) {
        print_attribormethodlist(cl->aormli);
    }
    printf("}\n");
}




void print_arg(arg *a) {
    printf("%s : %s", a->name, a->type);
}

void print_arglist(arglist *argli) {
    print_arg(argli->a);
    if (argli->next != NULL) {
        printf(", ");
        print_arglist(argli->next);
    }
}

void print_function(function *f) {
    printf("func %s(", f->name);
    if (f->args != NULL) {
        print_arglist(f->args);
    }
    printf(") : %s\n", f->type);
    print_instr(f->ins, 0, 0);    
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

void print_ifinstr(ifinstr *ifins, int indent) {
    print_indent(indent);
    printf("if(");
    print_expr(ifins->cond);
    printf(")\n");
    print_instr(ifins->yes, indent, 0);
    if (ifins->no != NULL) {
        print_indent(indent);
        printf("else\n");
        print_instr(ifins->no, indent, 0);
    }
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
        case LE:
            print_expr(e->left);
            printf(" <= ");
            print_expr(e->right);
            break;        
        case LT:
            print_expr(e->left);
            printf(" < ");
            print_expr(e->right);
            break;
        case GT:
            print_expr(e->left);
            printf(" > ");
            print_expr(e->right);
            break;
        case GE:
            print_expr(e->left);
            printf(" >= ");
            print_expr(e->right);
            break;
        case EQ:
            print_expr(e->left);
            printf(" == ");
            print_expr(e->right);
            break;        
        case NEQ:
            print_expr(e->left);
            printf(" != ");
            print_expr(e->right);
            break;
        case OR:
            print_expr(e->left);
            printf(" || ");
            print_expr(e->right);
            break;
        case AND:
            print_expr(e->left);
            printf(" && ");
            print_expr(e->right);
            break;
        case NOT:
            printf("!");
            print_expr(e->left);
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
            break;
        case IF:
            print_ifinstr(ins->ifins, indent);
            break;
        case SKIP:
            //printf("skip;\n");
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

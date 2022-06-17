#ifndef TYPES_INCLUDED
#define TYPES_INCLUDED

typedef struct prgm {
    struct class *cl;
} prgm;

typedef struct var {
    char *name;
} var;

typedef struct typ {
    int type; // IDENT, PTR
    char *name;
    struct typ *p;
} typ;

typedef struct lvalue {
    int type; // VAR, DOT
    struct var *v;
} lvalue;

typedef struct block {
    int type; // INSTR, CLASS
    struct instrlist *insli;
} block;

typedef struct forloop {
    struct instr *init;
    struct expr *cond;
    struct instr *end;
    struct instr *ins;
} forloop;

typedef struct whileloop {
    struct expr *cond;
    struct instr *ins;
} whileloop;

typedef struct ifinstr {
    struct expr *cond;
    struct instr *yes;
    struct instr *no;
} ifinstr;

typedef struct arg {
    struct var *v;
    struct typ *t;
} arg;

typedef struct arglist {
    struct arg *a;
    struct arglist *next;
} arglist;

typedef struct function {
    char *name;
    struct arglist *args;
    struct typ *type;
    struct instr *ins;
} function;


typedef struct attrib {
    struct var *v;
    struct typ *t;
} attrib;

typedef struct method {
    char *name;
    struct arglist *args;
    struct typ *type;
    struct instr *ins;
} method;

typedef struct attribormethod {
    int type; // ATTRIB, METHOD
    struct attrib *att;
    struct method *meth;
} attribormethod;

typedef struct attribormethodlist {
    struct attribormethod *aorm;
    struct attribormethodlist *next;
} attribormethodlist;

typedef struct class {
    char *name;
    struct attribormethodlist *aormli;
} class;

typedef struct instr {
    int type; // ASSIGN, DECL, BLOCK, SKIP, FOR, WHILE, IF
    struct assign *a;
    struct decl *d;
    struct block *bl;
    struct forloop *fl;
    struct whileloop *wl;
    struct ifinstr *ifins;
} instr;

typedef struct instrlist {
    struct instr *ins;
    struct instrlist *next;
} instrlist;

typedef struct decl {
    char *name;
    char *type;
    struct expr *init;
} decl;

typedef struct assign {
    struct lvalue *lval;
    struct expr *e;
} assign;

typedef struct expr {
    int type; // VAR, INT, BOOL, STRING, PLUS, MINUS, TIMES, DIV, LE, LT, GE, GT, OR, AND, NOT, PARENTH
    struct var *v;
    int intValue;
    char *stringValue;
    int boolValue;
    struct expr *left;
    struct expr *right;
} expr;


#endif

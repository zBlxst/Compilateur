#ifndef TYPES_INCLUDED
#define TYPES_INCLUDED

typedef struct prgm {
    struct block *bl;
} prgm;

typedef struct var {
    char *name;
} var;

typedef struct lvalue {
    int type; // VAR, DOT
    struct var *v;
} lvalue;

typedef struct block {
    int type; // INSTR, CLASS
    struct instrlist *insli; 
} block;


typedef struct instr {
    int type; // ASSIGN, DECL, BLOCK, SKIP
    struct lvalue *lval;
    struct expr *e;
    struct decl *d;
    struct block *bl;
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

typedef struct expr {
    int type; // VAR, IEXPR, SEXPR
    struct var *v;
    struct iexpr *i;
    struct sexpr *s;

} expr;

typedef struct iexpr {
    int type; // PLUS, MINUS, STAR, DIV, INT, LPARENT
    struct iexpr *left;
    struct iexpr *right;
    int value;
} iexpr;

typedef struct sexpr {
    int type; // PLUS, STRING
    struct sexpr *left;
    struct sexpr *right;
    char *value;
} sexpr;


#endif


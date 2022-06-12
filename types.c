/* 
Data structures    
*/

#ifndef TYPES_INCLUDED
#define TYPES_INCLUDED

typedef struct iexpr {
    int type; // IDENT, PLUS, MINUS, STAR, DIV, INT
    char *name; 
    struct iexpr *left;
    struct iexpr *right;
    int value;
} iexpr;

typedef struct sexpr {
    int type; // IDENT, PLUS
    char *name; 
    struct sexpr *left;
    struct sexpr *right;
    char *value;
} sexpr;

typedef struct prgm {
    struct sexpr *s;
} prgm;

typedef struct expr {
    struct iexpr *i;
} expr;

typedef struct decl {
    char *name;
    char *type;
    struct expr *init;
} decl;

#endif


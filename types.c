/* 
Data structures    
*/

#define TYPES_INCLUDED

typedef struct iexpr {
    int type; // IDENT, PLUS, MINUS, STAR, DIV, INT
    char *name; 
    struct iexpr *left;
    struct iexpr *right;
    int value;
} iexpr;

typedef struct prgm {
    struct decl *d;
} prgm;

typedef struct expr {
    struct iexpr *i;
} expr;

typedef struct decl {
    char *name;
    char *type;
    struct expr *init;
} decl;

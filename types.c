/* 
Data structures    
*/

typedef struct iexpr {
    int type; // IDENT, PLUS, MINUS, STAR, DIV, INT
    char *name; 
    struct iexpr *left;
    struct iexpr *right;
    int value;
} iexpr;

typedef struct prgm {
    struct iexpr *i;
} prgm;

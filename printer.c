#ifndef TYPES_INCLUDED
#include "types.c"
#endif

void print_prgm (prgm *p) {
    printf("%d\n", p->i->left->value);
}

#ifndef TYPES_INCLUDED
#include "types.c"
#endif

#define PRINTER_INCLUDED

void print_prgm (prgm *p) {
    printf("%d\n", p->i->left->value);
}

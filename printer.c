#ifndef TYPES_INCLUDED
#include "types.c"
#endif

#define PRINTER_INCLUDED

void print_prgm (prgm *p) {
    printf("var %s : %s = ", p->d->name, p->d->type);
}

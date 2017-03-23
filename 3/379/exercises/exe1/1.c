#include <stdio.h> 
#include <stdlib.h>


int main() {
        int *sam;
        int george;
        void *p1, *p2;
        p1 = malloc(1 * sizeof(int));
        p2 = malloc;
        sam = ((int *)p1) + 4;
        /* base your answers on this point in the program */
        printf("%p\n",p2);
        printf("%p\n",p1);
        printf("%p\n",&sam);
}

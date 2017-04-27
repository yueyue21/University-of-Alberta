#include <stdio.h>
 
void foo()
{
    /*static*/ int x = 5;
    x++;
    printf("%d\n", x);
}

int main()
{
    foo();
    foo();
    return 0;
}


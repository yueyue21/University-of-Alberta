#include <stdio.h>
int main(void)
{
	int a = 10;
	printf("&a = %p,a = %d\n",&a,a);
	int *x = &a;
	printf("*x = %d, x = %p, &x = %p,%d\n",*x,x,&x,*x);
	return 0;
}

#include <stdio.h>
void swapv(int x, int y)
{
	int tem = x;
	x = y;
	y = tem;
}
void swapr(int *x, int *y)
{
	int tem = *x;
	*x = *y;
	*y = tem;
}

int main(void)
{
	int a = 12, b = 9;
	printf("before v: a = %d, b = %d\n",a,b);
	swapv(a,b);
	printf("after v: a = %d, b = %d\n",a,b);
	
	int c = 7, d = 5;
	printf("before r: c = %d, b = %d\n",c,d);
	swapr(&c,&d);
	printf("after r: c = %d, b = %d\n",c,d);
}

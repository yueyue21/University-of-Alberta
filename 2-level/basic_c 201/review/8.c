#include <stdio.h>
int main()
{
	//char* names[] = {"Joe", "Davood", "Tod", "Ops",0};
	char name[][] = {{'J','o','e', 0},{ "Davood", "Tod", "Ops",0};
	//printf("names: %p\n", names);
	for (int i = 0; name[i]!=0;i++){
		//printf("&names[%d]: %p , names[%d]: %p , names[%d]: %s,%c\n",i, &names[i],i, names[i],i, names[i],*names[i]);
		printf("&name[%d]: %p ,name[%d]: %c\n",i,&name[i],i, name[i]);//[i]);	
	}
} 

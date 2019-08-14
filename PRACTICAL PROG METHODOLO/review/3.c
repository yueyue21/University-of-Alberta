#include <stdio.h>
#include <stdlib.h>
#define number 10
void fillup(const int array[],int a){
	for (int i = 0;i < a;i+=1){
		printf("%d\n",array[i]);
		//array[i] = rand()%100;		
	}
}
int main(void){
	int aoe[100];
	fillup(aoe,number);
	for(int k = 0;k<10;k++){
		printf("%d\n",aoe[k]);
	}
	//printf("\n");
	return 0;
}


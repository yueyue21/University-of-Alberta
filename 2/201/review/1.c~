#include <stdio.h>
#define am 256
int main(){
	int counts[am]={0};
	int ch;

	while((ch = getchar()) != EOF){
			counts[ch]++;
			printf("************%d\n", ch);
			printf("------------%d\n",*(counts + ch));
			printf("!!!!!!!!!!!!%d\n",counts[ch]);
	}
	for (ch = 0; ch<am;ch++){
		if(counts[ch]>0 ){
				printf("'%c'\t%d\n",(unsigned char) ch, counts[ch]);	
		}	
	}	
	return 0;	
}
		

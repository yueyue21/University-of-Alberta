#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int main(void){
		char p[100] = "e1234d6789";
		char *k = "ahello work";
		char *s="asdf";
		//s = "asdf"; // these are equal
	//	printf("%ld\n",sizeof(p));
//		printf("%c\n", *p[0]);
		//printf("%d\n",strnlen(p));	
		//printf("%c\n",p[0]);     // print the first element in "e454544..."	
		//printf("%d\n",*k);  //print a's acllec code(CMPUT229)
		//printf("%c\n",*(p+5));// print p[5]
		printf("%s\n",s);
		//printf("%s\n",s[0]);//his line is wrong since %s expects a address(pointer)
		printf("%c\n",p[5]);
		printf("%d\n",s[0]);		
		return 0;	
	}
/*

#include <stdio.h>

int main(void) {
    int count = printf("This is a test!\n");
    printf("%d\n", count);
 
    return 0;
}
*/

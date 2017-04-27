#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define WORDS 256

int main(void) {
    char *temp=NULL;
    char *list=NULL;
    char line[WORDS];
    long i=0;
    FILE *plist = NULL; 

    plist = fopen("input2.txt", "r");
    memset(line, 0, WORDS);
    list=malloc(1*sizeof(line));

    while(fgets(line, WORDS+1, plist)!=NULL) {
	strncpy(&list[i],line,WORDS);
	if (i==0){
 	  //printf("%d",atoi(&list[i]));
 	  temp=realloc(list,atoi(&list[i])*sizeof(line));
	  list=temp;
 	}
        i=i+WORDS;
	memset(line, 0, WORDS);
	
    }

    i=i-WORDS;
    for(; i >= 1; i=i-WORDS)
        printf("%s",&list[i]);
    return 0;    
}

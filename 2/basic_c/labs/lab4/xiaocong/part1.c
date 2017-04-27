#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define LINE 200
#define WORDS 257

int main(void) {
    char *list;
    char line[WORDS];
    long i=0;
    long c=LINE;
    FILE *plist = NULL; 

    plist = fopen("input1.txt", "r");
    memset(line, 0, WORDS);
    list=malloc(c*sizeof(list));

    while(fgets(line, WORDS+1, plist)!=NULL) {
	strncpy(&list[i],line,WORDS);
        i=i+WORDS;
	memset(line, 0, WORDS);
	
    }

    i=i-WORDS;
    for(; i >= 0; i=i-WORDS)
        printf("%s",&list[i]);
    return 0;    
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define LINE 10
#define WORDS 256

int main(void) {
    char *list;
    char line[256];
    long i=0;
    long c=10;
    FILE *plist = NULL; 

    plist = fopen("input3.txt", "r");
    memset(line, 0, WORDS);
    list=malloc(c*sizeof(line)/*256*/);

    while(fgets(line, WORDS+1, plist)!=NULL) {
	strncpy(&list[i],line,WORDS);
        i=i+WORDS;
	memset(line, 0, WORDS);
        if(i>=(c*WORDS)){
          c=c*2;
          list=realloc(list,c*sizeof(line));
        }
	
    }

    i=i-WORDS;
    for(; i >= 0; i=i-WORDS){
        printf("%s",&list[i]);
    }
    free(list);
    return 0;    
}

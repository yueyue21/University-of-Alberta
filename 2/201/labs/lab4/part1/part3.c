#include <stdio.h>
#include <stdlib.h>

char  term[10][265];
char ch;
int a = 1,b = 0;
int main(void){
  while ((ch = getchar()) != EOF){
    if (ch == '\n'){
      term[a][b] = ch;
      a ++;
      b = 0;	
    }
    else{
      term[a][b] = ch;
      b ++;	
    }	
  }
  while(a != 0){
    printf("%s",term[a]);		
    //printf("\n");
    a = a - 1;
  }
  return 0;
}

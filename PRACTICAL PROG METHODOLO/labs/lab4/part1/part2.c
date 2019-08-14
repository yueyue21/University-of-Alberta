#include <stdio.h>

char ch;
int a,c,b = 0;
int main(void){
  scanf("%d",&c);
  char  term[c][265];
  a = 0;
  while(a< c){
    while(b < 265){
      term[a][b] = "\0";
      b++;		
    }
    a ++;
  }
  while ((ch = getchar()) != EOF){
    if (ch == "\n"){
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
	
    while(term[a][b] !="\0"){
      printf("%c",term[a][b]);
	b ++;	
	}
    a = a - 1;
  }
  return 0;
}


/* CMPUT 201 
 Written by: Yue YIN (1345121)*/

#include <stdio.h>

int main() {
  char ch;
  int isSpaceOrTab = 0;
  int isHtml = 0;
  int isbl = 0;                            // isbl == is blank line
  // int ln3 = 0;                              // ln3 == check if it is the 3rd \n
  while ((ch=getchar()) != EOF) {
    if (ch != '<' && !isHtml){                    //check the html
      if (ch != ' ' && ch != '\t') {            // check the space and tab
       	if (ch != '\n'){
	  putchar(ch);
	  isbl = 0;
	  // ln3 = 0;
	}
	else if (ch == '\n' && !isbl) {
	  putchar(ch);
	  isbl = 1;
	}
	/*	else if (ch == '\n' && isbl && !ln3){
	  putchar(ch);
	  ln3 = 1;
	  }*/
	isSpaceOrTab = 0;
      }
     
      else if (!isSpaceOrTab && !isbl) {
	putchar(' ');
	isSpaceOrTab = 1;
      }
    }
    else {
      if(ch == '>'){
	isHtml = 0;
      }
      else {
	isHtml = 1;
      }
    }
  }
  return 0;
}

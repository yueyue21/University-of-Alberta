#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char*argv[])
{
  long letter, word;
  char ch;

  letter = 0;
  word = 0;
  if(argc == 2){
    char * input1 = argv[1];
    int i,relatedword,isNewWord;
    i = 1;
    isNewWord = 1;
    while ((ch =getchar()) !=EOF){
      if (ch != ' ' && ch != '\t' && ch != '\n'){
	relatedword = 1;
	if (tolower(ch) != input1[0]){
	  letter ++;
	  isNewWord = 1;
	}     
	else if(tolower(ch) == input1[0] && relatedword){
	  letter ++;
	  relatedword = 1;
	  ch = getchar();//further comparision starts from the 2nd letter.
	  
	  for(i = 1;tolower(ch) == input1[i] && relatedword && i <= strlen(input1) - 1;i++){
	    if(ch != input1[i]){
	      letter ++;
	      relatedword = 0;
	    }
	    else if(tolower(ch) == input1[i] && i == strlen(input1) - 1){ // last letter in the checking word.
	      letter ++;
	      printf("%ld,%ld,%s\n",letter,word,input1);
	    }
	    else{
	      letter++;
	      ch = getchar();
	    }
	  }
	}
      }
      else if((ch == ' ' || ch == '\t' || ch == '\n')) {
	if(isNewWord){
	  word ++;
	  letter ++;
	  isNewWord = 0;
	}
	else if(!isNewWord){
	  letter ++;
	}
      }
    }
  }
  else if(argc == 3){
    
  }

return 0;


}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char *argv[]){
  long letter, word;
  char term[200][40];
  int right[200],length[200];
  char ch,ck;                                // ck is the letter in checking file
  int isrf,iscf,rfindex,cfindex,arg_index;  // inputindex is the index of the input file in argv
  int a,b;                                 // index of the term. term[a][b]                                
  int c;                                 // the first index of term. when using it
  int x;                                // index of the array that contains the matched step for each,
  int isNewWord;
  FILE *fpr;
  FILE *fpc;
  // identify if there is or are readfile(rf) or checkfile(cf)
  rfindex = 0;        
  cfindex = 0;
  isrf = 0;
  iscf = 0;
  letter = 0;
  word = 0;
  if (argc <=5){
    for (arg_index = 0; arg_index < argc; arg_index ++){
      if(strcmp(argv[arg_index],"-f") == 0){
	isrf = 1; 
	rfindex = arg_index + 1;      //give the next index to rfindex as the readfile index.
      }
      else if(strcmp(argv[arg_index],"-l") == 0){
	iscf = 1;
	cfindex = arg_index + 1;     
      }
    }
    
    // open the readfile and checkfile if possible
    if(isrf == 1){
      fpr = fopen(argv[rfindex],"r");
    }
    if(iscf == 1){          
      a = 0;
      b = 0;
      fpc = fopen(argv[cfindex],"r");
      while((ck=fgetc(fpc)) != EOF){
	if(ck != '\n'){
	  term[a][b] = ck;
	  b++;
	}
	else{
	  length[a]=b-1;
	  a++;
	  b = 0;
	}
      }
      a = a-1;
      while (x != a){
	right[x] = 0;   // create a array that contain all 0 with a+1 positions
	x++;
      }
     fclose(fpc);
    }
  }
  else{
    printf("invild input,arguments is too long");
  }
  //***********************************************************
  //*********************CASES*********************************
  //***********************************************************
  //-----output1------- standard case--------------------------  
  
  if(argc == 2){     // when argc == 2 there is no -f or -l
    char *input1 =  argv[1];      
    int i,isNewWord;
    i = 0;
    isNewWord = 1;
    while ((ch =getchar()) !=EOF){
      letter ++;
      if (isalnum(ch)){
	if(isNewWord){
	  word++;
	  isNewWord = 0;
	}
      }
      else{
	isNewWord = 1;
      }

      if(i+1 == strlen(input1)){
	printf("%ld,%ld,%s\n",letter+1-strlen(input1),word,input1);
	i = 0;
      }
      else{
	if(tolower(ch) == input1[i]){
	  i ++;
	}
	else{
	  i = 0;
	}
      }
    }
  }
  
  //------------output2-------- there is -f but no -l-----------------
  
  else if(argc == 4 && isrf == 1 && iscf == 0){
    int i,isNewWord;
    i = 0;
    isNewWord = 1;
    // check the position of the readfile and check work in arguement
    if (rfindex == 2){  //default option, term is at argv[3]
      while ((ch = fgetc(fpr)) !=EOF){
	letter ++;
	if (isalnum(ch)){
	  if(isNewWord){
	    word++;
	    isNewWord = 0;
	  }
	}
	else{
	isNewWord = 1;
	}

	if(i+1 == strlen(argv[3])){
	  printf("%ld,%ld,%s\n",letter+1-strlen(argv[3]),word,argv[3]);
	i = 0;
	}
	else{
	  if(tolower(ch) == argv[3][i]){
	    i ++;
	  }
	  else{
	    i = 0;
	  }
	}
      }
    }
    else{      
      while ((ch = fgetc(fpr)) !=EOF){
	letter ++;
	if (isalnum(ch)){        // check the word index
	  if(isNewWord){
	    word++;
	    isNewWord = 0;
	  }
	}
	else{
	  isNewWord = 1;
	}

	if(i+1 == strlen(argv[1])){
	  printf("%ld,%ld,%s\n",letter+1-strlen(argv[1]),word,argv[1]);
	  i = 0;
	}
	else{
	  if(tolower(ch) == argv[1][i]){
	    i ++;
	  }
	  else{
	    i = 0;
	  }
	}
      }
    }
  } 
  //----------------output3-------------there is -l but no -f
	
  else if (argc == 3 && isrf == 0 && iscf == 1){
    isNewWord = 1;
    c = 0;
    while((ch = getchar()) != EOF){
      letter ++;
      if (isalnum(ch)){
	if(isNewWord){
	  word++;
	  isNewWord = 0;
	}
      }
      else{
	isNewWord = 1;
      }
      
      while(c <= a){
	if(tolower(ch) == term[c][right[c]]){   // compare the current ch with word term[c] at position of right[c], where right[c] is how many letter matched.
	  if(length[c] == right[c]){
	    printf("%ld,%ld,%s\n",letter-3,word,term[c]);
	    right[c] = 0;   // if print, then clear the number in position [c].
	  }
	  right[c]++;   // the array right in position c(for the word) will store how further they matched
	}
	else{
	  right[c]=0;
	}
	c ++;        // if or not if ch == term[0][0], the next comparision is between ch and term[1][0]
      }
      c = 0;
    }
  } 
  //----------------------output4-----------------there are -f and -l-----------
  else if (argc == 5 && isrf == 1 && iscf == 1){
    isNewWord = 1;
    c = 0;
    while((ch = fgetc(fpr)) != EOF){
      letter ++;
      if (isalnum(ch)){
	if(isNewWord){
	  word++;
	  isNewWord = 0;
	}
      }
      else{
	isNewWord = 1;
      }
      
      while(c <= a){
	if(tolower(ch) == term[c][right[c]]){   // compare the current ch with word term[c] at position of right[c], where right[c] is how many letter matched.
	  if(length[c] == right[c]){
	    printf("%ld,%ld,%s\n",letter - 3, word, term[c]);
	    right[c] = 0;   // if print, then clear the number in position [c].
	  }
	  right[c]++;   // the array right in position c(for the word) will store how further they matched
	}
	else{
	  right[c]=0;
	}
	c ++;        // if or not if ch == term[0][0], the next comparision is between ch and term[1][0]
      }
      c = 0;
    }
  } 
  else{
    printf("the input argument is invalid");
  }
  return 0;
}
  
  

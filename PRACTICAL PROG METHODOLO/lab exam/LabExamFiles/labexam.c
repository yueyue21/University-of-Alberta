// Starter file for 201 lab exam 

// You may add other includes here.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>


// You may add global variables, declarations and/or
// definitions, struct type definitions, macros or function declarations
// here

//e.g.
//#define MAXBUF 80

void do_section1();
void do_section2();
void do_section3();
void do_section4();

// do not modify this main function in any way ... don't touch it.
// main checks for some errors, for your convenience - it may make 
// debugging easier.
int main(int argc, char *argv[])
{
  if (argc != 2)
  {
    fprintf(stderr, "error: required argument not given\n");
    fprintf(stderr, 
            "       usage example: ./labexam 1 < input_file > output_file\n"); 
    exit(EXIT_FAILURE);
  }

  int which_section;
  int ret_val = sscanf(argv[1], "%d", &which_section); 
  if (ret_val != 1)
  {
    fprintf(stderr, "error: argument is not a number, %s\n",
                    argv[1]);
    exit(EXIT_FAILURE);
  }
 
  switch(which_section)
  {
    case 1:
      do_section1();
      break;
    case 2:
      do_section2();
      break;
    case 3:
      do_section3();
      break;
    case 4:
      do_section4();
      break;
    default:
      fprintf(stderr, "error: argument is not between 1 and 4, %s\n",
                      argv[1]);
      exit(EXIT_FAILURE);
  }
  
}
 
// Add your code below this line.  If needed, create other helper functions.
//============================================================================


void do_section1()
{
  // Add code here that does what is needed for Section 1.  Free up all
  // memory allocated (if you have allocated memory).  You may call
  // other functions you create.
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
}
 

void do_section2()
{
  // Add code here that does what is needed for Section 2.  Free up all
  // memory allocated (if you have allocated memory).  You may call
  // other functions you create.
	char ch;
	long index=0,word=0;
	char term[256][40];
	int position[256];
	int key=1;
	while ((ch=getchar()) != EOF){
		if(!isalnum(ch)){
			//printf("%ld\n",index);
			key=1;
			index=0;
			word++;
		}
		else {
			term[word][index]=ch;	
			if(key==1){
				position[word]=index;
				key=0;
				//printf("werwerwe");
			}
			//printf("----%d--%ld=-==%ld\n",position[word],index,word);
			//printf("%d\n",position[word]+1);
			index++;
			
		}
		//printf("%ld\n",index);*/
	}
	for(long i=0;i<word;i++){
		printf("%d,%s\n",position[i]+1,term[i]);
	}
}
  
void do_section3()
{
  // Add code here that does what is needed for Section 3.  Free up all
  // memory allocated (if you have allocated memory).  You may call
  // other functions you create.

}

void do_section4()
{
  // Add code here that does what is needed for Section 4.  Free up all
  // memory allocated (if you have allocated memory).  You may call
  // other functions you create.
}


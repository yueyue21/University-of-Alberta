#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "memwatch.h"

#define sizeint 256
#define sizeterm 40

//int HaveOption = 0;	/*set a swich to check if there is an option*/
void getterm(FILE *termfp,FILE *readfp,char **term,int *right,int *length,long *space_num,long str1,long str2,int BS,int CTS,int TS,int CS,long letter,long word,int *cdis,int *tdis);
void search_std(FILE*readfp,char*search_term,long letter,long word);
void search_nonearby(FILE*readfp,char **term,long letter,long word,int *right,int *length,long str1,long *space_num);
void search_nearby_multi_term();
void search_nearby_multi_char();
void search_nearby_single_term(FILE*readfp,char*search_term,long letter,long word,char *nb,int *tdis);
void search_nearby_single_char(FILE*readfp,char*search_term,long letter,long word,char *nb,int *cdis);
int main(int argc, char *argv[]){ 
  int FS=0,LS=0,BS=0,CTS=0,TS=0,CS=0;/*set a switch to indicate if there is -f,-l,-b,-t or -c,-t,-c option*/
  FILE *readfp=NULL; 	/*declare the readfile pointers*/
  FILE *termfp=NULL; 	/*declare the termfile pointer*/
  char *nb=0,*search_term=0;	/*declare the nearby term pointer,search term pointer*/
  char **term=0;	/*creat a array of potiners for search term*/
  int *right=0,*length=0;/* memory pointer to store the extent of matched term, the term length and #of spaces in term*/
  long *space_num=0;/*#of spaces in term*/
  long letter=0,word=0;	/*the two numbers for each mentioned term*/
  int *tdis=0;	/*declare the term distance pointer*/
  int *cdis=0;	/*declare the char distance pointer*/
  long str1=0;	/*first peremeter,indicates a term*/
  long str2=0;	/*second peremeter,indicates a char within a term*/
  for(int i=1; i<argc; i++)
    {
      if(argv[i][0]=='-')
	{	
	  //HaveOption = 1;
	  switch(argv[i][1])
	    {
	    case'f':
	      if(strlen(argv[i])!=2)
		readfp=fopen(&argv[i][2],"r");
	      else
		readfp=fopen(argv[i+1],"r");	/*open readfile*/
	      FS=1;	/*set the switch as 1 to indicate if there is -f option*/
	      break;
	    case'l':
	      if(strlen(argv[i])!=2)
		termfp=fopen(&argv[i][2],"r");		
	      else
		termfp=fopen(argv[i+1],"r");	/*open termfile*/
	      LS=1;	/*set the switch as 1 to indicate if there is -l option*/
	      break;
	    case'b':
	      if(strlen(argv[i])!=2)
		nb = &argv[i][2];
	      else
		nb = argv[i+1];	/*initialize nearby term*/
	      BS=1;	/*set the switch as 1 to indicate if there is -b option*/
	      break;
	    case't':
	      if(strlen(argv[i])!=2)
		sscanf(argv[i],"-t%d",tdis);
	      else
		*tdis = atoi(argv[i+1]);	/*initalize term distance*/
	      CTS=1;	/*set the switch as 1 to indicate if there is -t or -c option*/
	      TS=1;	/*set the switch as 1 to indicate if there is -t option*/	
	      *tdis = atoi(argv[i+1]);	/*initalize term distance*/
	      break;				
	    case'c':
	      CTS=1;	/*set the switch as 1 to indicate if there is -t or -c option*/
	      CS=1;	/*set the switch as 1 to indicate if there is -c option*/
	      if(strlen(argv[i])!=2)
		sscanf(argv[i],"-c%d",cdis);
	      else
		*cdis = atoi(argv[i+1]);	/*initialize char distance*/
	      break;
	    default:
	      printf("Undifined option:-%c\n",argv[i][1]);			
	    }
	}
      else
	search_term = argv[i];	/*just for the case that input is a term,here use termfp point this term.LS==0*/	
    }
  if(FS==0)	/*deal with if there is a -f,done*/
    readfp = stdin;	/*in case of the standard input*/
  else
    FS = 1;// just handle the previous if
  if(LS==1){   /*we have -l option*/
    getterm(termfp,readfp,term,right,length,space_num,str1,str2,BS,CTS,TS,CS,letter,word,cdis,tdis); /*get an array of all the search term*/
  }
  else{
    if(BS==0)
      search_std(readfp,search_term,letter,word);/*std input searching*/
    else{
      if(CTS==0){//CHECK DEFAULT
	*tdis=5;/*regard the five is get from input,using term nearby function to excute*/
	search_nearby_single_term(readfp,search_term,letter,word,nb,tdis);//1
      }
      else{
	if(CS==1){
	  search_nearby_single_char(readfp,search_term,letter,word,nb,cdis);//2
	}
	else if(TS==1){
	  search_nearby_single_term(readfp,search_term,letter,word,nb,tdis);
	}
      }
    }
  }
  return 0;
}
/*-------------------------------------------------------------------------------------*/
void getterm(FILE *termfp,FILE *readfp,char **term,int *right,int *length,long *space_num,long str1,long str2,int BS,int CTS,int TS,int CS,long letter,long word,int *cdis,int *tdis){
  char ck;	/*ck is for char in termfile when searching*/
  long size1=sizeint; /*number of terms*/
  long size2=sizeterm;/*number of chars in a term*/
  term=malloc(size1*sizeof(char*));
  memset(term,0,size1*sizeof(char*));

  right=malloc(size1*sizeof(char*));
  memset(right,0,size1*sizeof(char*));

  length=malloc(size1*sizeof(char*));
  memset(length,0,size1*sizeof(char*));

  space_num=malloc(size1*sizeof(char*));
  memset(space_num,0,size1*sizeof(char*));

  term[str1]=malloc((size2+1)*sizeof(char));
  memset(term[str1],0,(size2+1)*sizeof(char));
  while((ck=fgetc(termfp))!=EOF){
    if(ck!='\n'){
      if(ck==' ')
	space_num[str1]++;/*space_num store # of spaces the term have by the order given*/
      term[str1][str2]=ck;
      str2++;
      }
    else{
      if(str1+1>=size1){	/*avoid overload*/
	size1=size1*2;	/*double the size*/
	term=realloc(term,size1*sizeof(char*));
	memset(term[size1/2-1],0,(size1/2+1)*sizeof(char*));

	right=realloc(right,size1*sizeof(char*));
	memset(right+(size1/2-1),0,(size1/2+1)*sizeof(char*));
	length=realloc(length,size1*sizeof(char*));
	memset(length+(size1/2-1),0,(size1/2+1)*sizeof(char*));
	space_num=realloc(space_num,size1*sizeof(char*));
	memset(space_num+(size1/2-1),0,(size1/2+1)*sizeof(char*));
      }
      length[str1]=str2-1;/*length stores the length of each term -1 by order given*/ 
      str1++;
      term[str1]=malloc((size2+1)*sizeof(char));
      memset(term[str1],0,(size2+1)*sizeof(char));
      str2=0;  
    }			
  }
  fclose(termfp);
  if(BS==0){ /*not have -b option*/
    search_nonearby(readfp,term,letter,word,right,length,str1,space_num);
  }
  else{
    if(CTS==0){
      *tdis=5;/*regard the five is get from input,using term nearby function to excute*/
      search_nearby_multi_term();//1
    }
    else{
      if(CS==1){
	search_nearby_multi_char();//2
      }
      else if(TS==1){
	search_nearby_multi_term();//1
      }
    }
  }	
}
/*--------------------------------------------------------------------------------------*/
void search_std(FILE*readfp,char*search_term,long letter,long word){
  char ch;
  int isNewWord=1,i=0;/*a switch, a peremeter for counted number*/
  while ((ch =fgetc(readfp)) !=EOF){
    letter++;
    if (isalnum(ch)){
      if(isNewWord){
	word++;
	isNewWord = 0;
      }
    }
    else{
      isNewWord = 1;
    }
    
    if(i+1 == strlen(search_term)){
      printf("%ld,%ld,%s\n",letter+1-strlen(search_term),word,search_term);// since there's no space in the search term in this case
      i = 0;
    }
    else{
      search_term[i]=tolower(search_term[i]);
      if(tolower(ch) == search_term[i]){
	i ++;
      }
      else{
	i = 0;
      }
    }
  }
}
/*--------------------------------------------------------------------------------*/
void search_nonearby(FILE*readfp,char **term,long letter,long word,int *right,int *length,long str1,long *space_num){
  char ch;
  long isNewWord = 1, i = 0,k = 0;/* term[i]=ith term in the array*/
  while((ch = fgetc(readfp)) != EOF){
    letter++;
    if (isalnum(ch)){
      if(isNewWord){
	word++;
	isNewWord = 0;
      }
    }
    else
      isNewWord = 1;
    while(i <= str1){
      term[i][right[i]]=tolower(term[i][right[i]]);//covet all the term kept to lower
      if(tolower(ch) == term[i][right[i]]){// compare the current ch with word term[i] at position of right[i], where right[i] is how many letter matched.
	if(length[i] == right[i]){
	  printf("%ld,%ld,%s\n",letter - 3, word-space_num[i], term[i]);// word - number of spaces in term.
	  right[i] = 0;   // if print, then clear the number in position [i].
	}
	right[i]++;   // the array right in position c(for the word) will store how further they matched
      }
      else
	right[i]=0;
      i ++;        // if or not if ch == term[0][0], the next comparision is between ch and term[1][0]
    }
    i = 0;
  }
  for(k=0;k<=str1;k++)
	free(term[k]);// sooooooo tricky
  free(term);
  free(right);
  free(length);
  free(space_num);
}
/*-------------------------------------------------------------------------------------*/
void search_nearby_multi_term(){
  
}
/*--------------------------------------------------------------------------------------*/
void search_nearby_multi_char(){
  
}
/*-----------------------------------------------------------------------------------*/
void search_nearby_single_term(FILE*readfp,char*search_term,long letter,long word,char *nb,int *tdis){
  
}
/*-----------------------------------------------------------------------------------*/
void search_nearby_single_char(FILE*readfp,char*search_term,long letter,long word,char *nb,int *tdis){

}
/*-----------------------------------------------------------------------------------*/



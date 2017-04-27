/* 
 CMPUT 379 Assignment1
 Prof: 		Martha White 
 Student: 	Yue YIN (1345121)
 Section:	B1
 */

#include <err.h>
#include <errno.h>
#include <limits.h>
#include <setjmp.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "memchunk.h"

struct memchunk {
  	void *start;
  	unsigned long length;
  	int RW;
};

static void handler(int signum) {
  	if (a==0 && b == 0){	/* worthless case*/
    		pre_not_read = 1;
    	pre_not_write = 1;
  	}
  	else{//(a == 1 && b == 0)
    		if(!pre_not_read && pre_not_write){	/*same as pre*/
     			 chunk_list[chunk_number].length ++;
      			pre_not_read = 0;
      			pre_not_write = 1;
      			}
    		else{					/* different*/
      			chunk_number ++;
			chunk_list[chunk_number].start = start;
			chunk_list[chunk_number].RW = 0;
			chunk_list[chunk_number].length ++;
			pre_not_read = 0;
			pre_not_write = 1;
			}
		}
	start += getpagesize();
	siglongjmp(jumpbuf, 1);
}
      	
get_mem_layout (struct memchunk *chunk_list, int size){
	sa.sa_handler = handler;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	if (sigaction(SIGSEGV, NULL, &oldsa) == -1)
		err(1, "can't save old sigaction");
 	if (sigaction(SIGSEGV, &sa, NULL) == -1)
    		err(1, "can't do new sigaction");
  	while(1) {
    		if (sigsetjmp(jumpbuf, 1) == 0)
      			sleep(0);
    		if(last || (chunk_number+1) >= size){
      			break;
	    	}
	    	a=0;
	    	b=0;
	    	if(start < end){
	      		/*readable?*/
	      		p = *start;	
	      		a=1;
	      		/*writable?*/
	      		*start= *start;
	      		b=1;
	      		if(!pre_not_read && !pre_not_write){//same to the pre
				chunk_list[chunk_number].length ++;
				//no need to change the type and length
	      		}
	      		else{//type differ from pre page. 
				/*pre type is R but not W*/
				chunk_number ++;
				chunk_list[chunk_number].start = start;//new 
				chunk_list[chunk_number].RW = 1;
				chunk_list[chunk_number].length ++;
				pre_not_write=0;
				pre_not_read=0;
	     		}
	      		start += getpagesize();
	    	}
	    	if(start == end){
	      		/*readable?*/
	      		last = 1;
	      		p = *start;	
	      		a=1;
	     		/*writable?*/
	      		*start= *start;	
	      		b=1;
	      		if(!pre_not_read && !pre_not_write){//same to the pre
				chunk_list[chunk_number].length ++;
				//no need to change the type and length
	      		}
	      		else{//type differ from pre page. 
				/*pre type is R but not W*/
				chunk_number ++;
				chunk_list[chunk_number].start = start;//new 
				chunk_list[chunk_number].RW = 1;
				chunk_list[chunk_number].length ++;
				pre_not_write=0;
				pre_not_read=0;
	      		}
	      	break;
	    	}
  	}
  	return chunk_number+1;
}
int main(){
	int k;
  	int total_chunk;
  	int size=100;		/*the size of chunk_list by default*/
  	/*
   	*THIS PART DISPLAY THE CHUNKS GIVEN BY THE SYSTEM (only for testing)
   	*/
   	/*
   	char x[100];
  	FILE *fp = fopen("/proc/self/maps","r");
   	while(fgets(x,100,fp)){
   	printf("%s",x);
   	}
   	fclose(fp);
  	*/
  	/*
   	*THIS PART ENABLE THE USER TO INPUT THE BUFFER(buffer modification)
   	*printf("Please give a size of the list you want");
   	*printf("to place the information of chunks in intger(0~100):");
   	*scanf("%d",&size);
   	*/
  	chunk_list= malloc(size * sizeof(struct memchunk));
  	for (k = 0;k < size;k++){
    		chunk_list[k].length = 0;
  	};
  	total_chunk=get_mem_layout (chunk_list,size);
  	printf("---------------------------------------------------\n");
  	printf("---------------------------------------------------\n");
  	printf("The buffer of chunk list is 100 by default\n");
  	printf("You may modify the buffer by uncomment buffer");
  	printf(" modification part in the main function.\n");
  	printf("---------------------------------------------------\n");
  	printf("Total number chunks displayed:%d\n",total_chunk);
  	printf("Starting position Length(in byte)");
  	printf(" Type(0:read only,1:read & write)\n");
  	for (k = 0;k < total_chunk;k++){
    		printf("%-18p",chunk_list[k].start);
    		printf("%-16ld",(chunk_list[k].length)*4096);
    		printf("%-10d\n",chunk_list[k].RW);
  	};
  	free(chunk_list);	
}


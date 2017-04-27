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
//int get_mem_layout (struct memchunk *chunk_list, int size);
struct memchunk {
            void *start;
            unsigned long length;
            int RW;
        };

static void handler(int signum) {
	if (a==0 && b == 0){	/* worthless case*/
		pre_not_read = 1;
		pre_not_write = 1;
		//printf("a %d b %d %p\n",a,b,start);
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
		//printf("a %d b %d %p\n",a,b,start);
	}
	start += getpagesize();
	siglongjmp(jumpbuf, 1);
}
      	
void scan_mem(){
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
			printf("%d\n",chunk_number);
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
				chunk_list[chunk_number].start = start;//new item!
				chunk_list[chunk_number].RW = 1;
				chunk_list[chunk_number].length ++;
				pre_not_write=0;
				pre_not_read=0;
			}
			
			//printf("a %d b %d %p\n",a,b,start);
			start += getpagesize();
		}
		if(start == end){
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
				chunk_list[chunk_number].start = start;//new item!
				chunk_list[chunk_number].RW = 1;
				chunk_list[chunk_number].length ++;
				pre_not_write=0;
				pre_not_read=0;
			}
			//printf("a %d b %d %p\n",a,b,start);
			break;
		}
	}
}
int main()
{
	printf("Please enter the number of chunks you want to find in decimal:");
	scanf("%d",&size);
	chunk_list= malloc(size * sizeof(struct memchunk));
	int k;
	for (k = 0;k < size;k++){
		chunk_list[k].length = 0;
	};
	scan_mem();		//go scan the memory
	printf("starting position--length--type\n");
	for (k = 0;k < size;k++){
		printf("%p----%ld----%d\n",chunk_list[k].start,chunk_list[k].length,chunk_list[k].RW);
	};
	free(chunk_list);
	
}


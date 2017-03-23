#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

void *sillythread(void *threadid){
	int i,j;
	for (i = 0; i < 100000; i++)
		j +=1;
	pthread_exit*(NULL);
}
int main (int argc, char *argv[]){
	pthread_t threads[10000];
	int i;
	fork();
	fork();
	fork();
	for(i=0; i<5; i++)
		pthread_creat(&threads[i],NULL,sillythread,NULL);
	pthread_exit(NULL);
)

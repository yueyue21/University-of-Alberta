#include <sys/stat.h>
#include <sys/types.h>
#include <stdio.h>
#include <dirent.h>
#include <stdlib.h>

int main (){
	if(mkdir ("/cshome/yyin/workspace/379/assignments/assignment2/documents",0777) != -1){
		printf("success\n");
	}
	else{
		perror("");
		return EXIT_FAILURE;
	}
}

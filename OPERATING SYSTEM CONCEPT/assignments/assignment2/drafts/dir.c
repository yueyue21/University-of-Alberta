#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
int main(){
	DIR *dir;
	struct dirent *ent;
	if ((dir = opendir("/cshome/yyin/workspace/379/assignments/assignment2/documents")) != NULL){
		printf("Documents file exists files displays below:\n");
		while((ent = readdir (dir)) != NULL){
			printf("%s\n",ent->d_name);
		}	
		closedir(dir);	
	}
	else {
		if(mkdir ("/cshome/yyin/workspace/379/assignments/assignment2/documents",0777) != -1){
			printf("Directory does not exist, new dir created!\n");
		}
		else{
			perror("");
			return EXIT_FAILURE;
		}
	}
}

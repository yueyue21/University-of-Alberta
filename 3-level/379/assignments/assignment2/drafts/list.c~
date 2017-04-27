#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <string.h>
int main(){
	char filelist[255][64];
	int file_counter = 0;
	int i;
	DIR *dir;
	struct dirent *ent;
	if ((dir = opendir("/cshome/yyin/workspace/379/assignments/assignment2/documents")) != NULL){
		printf("Documents file exists files displays below:\n");
		while((ent = readdir (dir)) != NULL){
			strncpy(filelist[file_counter], ent->d_name,sizeof(filelist[file_counter]));
			//printf("%s\n",ent->d_name);
			file_counter++;
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
	for(i = 0;i < file_counter;i++){
		printf("%s\n",filelist[i]);
	}
}


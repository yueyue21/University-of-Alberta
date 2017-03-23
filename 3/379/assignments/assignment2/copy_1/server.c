
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <netinet/in.h>

#include <err.h>
#include <errno.h>
#include <limits.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>
int clientsd;

static void usage()
{
	extern char * __progname;
	fprintf(stderr, "usage: %s portnumber\n", __progname);
	exit(1);
}

static void kidhandler(int signum) {
	/* signal handler for SIGCHLD */
	waitpid(WAIT_ANY, NULL, WNOHANG);
}

void display (char *buffer){
	ssize_t written, w;
	w = 0;
	written = 0;
	while (written < strlen(buffer)) {
	w = write(clientsd, buffer + written, strlen(buffer) - written);
	if (w == -1) {
		if (errno != EINTR)
			err(1, "write failed");
	}
	else
		written += w;
	}
}

void read_input(char *buffer){
	ssize_t read1,r;
	r = 0;
	read1 = 0;
	r=read(clientsd, buffer + read1,strlen(buffer) - read1);
	if (r == -1){
		if (errno != EINTR)
			err(1,"read failed");
		}
}

char* check_first(char* buffer, char* feedback){
	if(strncmp("GET ",buffer,4) ==0){
		return (buffer +=4);
	}
	else{
		display(feedback);
	}
}

int main(int argc,  char *argv[])
{
	DIR *dir;    /*the dir is the dir contain the documents of server */
	struct dirent *ent;  /* of the dir's*/
	struct sockaddr_in sockname, client;
	char buffer[10], *ep,filelist[255][64],general[80];/*a file name is less than 64 char*/
	char input1[60],not_get[10];
	//strncpy(input1,"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",sizeof(input1));
	//memset(input1,'\0',sizeof(input1));
	struct sigaction sa;
	socklen_t clientlen;
        int sd,file_counter;
        file_counter = 0;
	u_short port;
	pid_t pid;
	u_long p;

	if (argc != 3)
		usage();
		errno = 0;
        p = strtoul(argv[1], &ep, 10);
        if (*argv[1] == '\0' || *ep != '\0') {
		fprintf(stderr, "%s - not a number\n", argv[1]);
		usage();
	}
        if ((errno == ERANGE && p == ULONG_MAX) || (p > USHRT_MAX)) {
		fprintf(stderr, "%s - value out of range\n", argv[1]);
		usage();
	}
	if ((dir = opendir(argv[2])) != NULL){
		printf("Documents file exists files displays below:\n");
		while((ent = readdir (dir)) != NULL){
			strncpy(filelist[file_counter], ent->d_name,
			sizeof(filelist[file_counter]));
			printf("%s\n",ent->d_name);
			file_counter++;
		}	
		closedir(dir);
	}
	if(mkdir (argv[2],0777) != -1){
			printf("Directory does not exist, new dir created!\n");
		}
	
	port = p;

	/* the message we send the client */
	strncpy(buffer,"\n",sizeof(buffer));
	strncpy(not_get,"BAD REQUEST",sizeof(not_get));
	strncpy(general,"Please enter the file name you want(^C for exit):",
	sizeof(general));     
	memset(&sockname, 0, sizeof(sockname));
	sockname.sin_family = AF_INET;
	sockname.sin_port = htons(port);
	sockname.sin_addr.s_addr = htonl(INADDR_ANY);
	sd=socket(AF_INET,SOCK_STREAM,0);
	if ( sd == -1)
		err(1, "socket failed");

	if (bind(sd, (struct sockaddr *) &sockname, sizeof(sockname)) == -1)
		err(1, "bind failed");

	if (listen(sd,3) == -1)
		err(1, "listen failed");

	sa.sa_handler = kidhandler;
        sigemptyset(&sa.sa_mask);
        sa.sa_flags = SA_RESTART;
        if (sigaction(SIGCHLD, &sa, NULL) == -1)
                err(1, "sigaction failed");
	printf("Server up and listening for connections on port %u\n", port);
	for(;;) {
		
		int print_counter=0; /*initialize the client display counter*/
		clientlen = sizeof(&client);
		clientsd = accept(sd, (struct sockaddr *)&client, &clientlen);
		if (clientsd == -1)
			err(1, "accept failed");
		/*
		 * We fork child to deal with each connection, this way more
		 * than one client can connect to us and get served at any one
		 * time.
		 */

		pid = fork();
		if (pid == -1)
		     err(1, "fork failed");

		if(pid == 0) {
			//ssize_t written, w;
			//ssize_t read1,r;
			
			/* display general information about file documents*/
			for(print_counter = 0;print_counter <file_counter;
			print_counter++){
				display (filelist[print_counter]);
				display (buffer);
			}
			display(general);
			/*                         
			*		get string from the input
			*/
			read_input(input1);
			display(input1);
			display (buffer);
			//check_first(input1,not_get);
			exit(0);
		}
		close(clientsd);
	}
	
	
	
	
	
	
	
}

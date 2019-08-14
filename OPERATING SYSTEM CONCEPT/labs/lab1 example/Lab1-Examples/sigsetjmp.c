#include <signal.h>
#include <setjmp.h>
#include <stdio.h>
#include <stdlib.h>

static sigjmp_buf env;
static void my_handler(int);

int main() {
	printf("Program Starting\n");
	signal(SIGSEGV, my_handler);
	int count = 0;
	int x = sigsetjmp(env,1);

	if(x == 0) {
		printf("setjmp called first time\n");
		raise(SIGSEGV);
	}
	else {
		printf("setjmp called from longjmp\n");

        count++;
		if(count == 5)
			exit(1);
		else {
			raise(SIGSEGV);
		}
	}

    exit(0);
}

void my_handler(int signo) {
	printf("SIGSEGV handler ...\n");
	siglongjmp(env, 1);
}

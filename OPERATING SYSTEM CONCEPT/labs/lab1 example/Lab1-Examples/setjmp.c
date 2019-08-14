#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>

static jmp_buf env;

void sig_handler(int signo) {
    longjmp(env, 1);
}

int main() {
    (void) signal(SIGSEGV, sig_handler);

    if(!setjmp(env))
        printf("Jump marker set\n");
    else {
        printf("Custom error: Segmentation fault occurred\n");
        exit(-1);
    }

    raise(SIGSEGV);
    exit(0);
}

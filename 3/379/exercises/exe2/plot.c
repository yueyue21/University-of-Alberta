#define NUMBER_OF_DARTS 50000000
#define NUMBER_OF_THREADS 2
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h> 
/* the number of hits in the circle */
int circle_count = 0;

int main (int argc, const char * argv[]) {
        int i, darts_per_thread;
        double estimated_pi;
        pthread_t workers[NUMBER_OF_THREADS];

        darts_per_thread = NUMBER_OF_DARTS/ NUMBER_OF_THREADS;

        for (i = 0; i < NUMBER_OF_THREADS; i++)
            pthread_create(&workers[i], 0, worker, &darts_per_thread);

        /* 
         * Finish the code, joining the threads and estimating pi
         * Hint: it's only a few lines (more than 1, no more than 5)
         */

         return 0;
}

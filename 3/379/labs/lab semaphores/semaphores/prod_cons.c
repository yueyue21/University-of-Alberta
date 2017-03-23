#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include </usr/include/semaphore.h>

#define BUFF_SIZE   5       /* total number of slots */
#define NP          3       /* total number of producers */
#define NC          3       /* total number of consumers */
#define NITERS      12       /* number of items produced/consumed */

typedef struct {
    int buf[BUFF_SIZE];   /* shared var */
    int in;               /* buf[in%BUFF_SIZE] is the first empty slot */
    int out;              /* buf[out%BUFF_SIZE] is the first full slot */
    sem_t full;           /* keep track of the number of full spots */
    sem_t empty;          /* keep track of the number of empty spots */
    sem_t prod_mutex;     /* enforce mutual exclusion to shared data for producers*/
    sem_t cons_mutex;     /* enforce mutual exclusion to shared data for consumers*/
} sbuf_t;

sbuf_t shared;

void *Producer(void *arg) {
    int i, item, index;

    index = (int)arg;

    for (i=0; i < NITERS; i++) {

        /* Produce item */
        item = (NITERS*index) + i;   

        /* Prepare to write item to buf */

        /* If there are no empty slots, wait */
        sem_wait(&shared.empty);
        /* If another thread uses the buffer, wait */
        sem_wait(&shared.prod_mutex);

        shared.buf[shared.in] = item;
        //printf("[P%d] shared.in = %d\n", index, shared.in);
        shared.in = (shared.in+1)%BUFF_SIZE;
        printf("[P%d] Producing %d ...\n", index, item);
        fflush(stdout);

        /* Release the buffer */
        sem_post(&shared.prod_mutex);
        /* Increment the number of full slots */
        sem_post(&shared.full);
    }
    return NULL;
}

void *Consumer(void *arg) {
    /* Fill in the code here */
    int i, item, index;

    index = (int)arg;

    for (i=0; i < NITERS; i++) {
        /* If there are no full slots, wait */
        sem_wait(&shared.full);

        /* If another thread uses the buffer, wait */
        sem_wait(&shared.cons_mutex);

        //printf("----> [C%d] shared.out = %d\n", index, shared.out);
        item = shared.buf[shared.out];
        shared.out = (shared.out+1) % BUFF_SIZE;
        printf("----> [C%d] Consuming %d ...\n", index, item);
        fflush(stdout);

        /* Release the buffer */
        sem_post(&shared.cons_mutex);
        /* Increment the number of emtpy slots */
        sem_post(&shared.empty);

    }
    return NULL;
}

int main() {
    pthread_t idP, idC;
    int index;

    sem_init(&shared.full, 0, 0);
    sem_init(&shared.empty, 0, BUFF_SIZE);
    sem_init(&shared.cons_mutex, 0, 1);
    sem_init(&shared.prod_mutex, 0, 1);
    shared.out = 0;
    shared.in = 0;

    for (index = 0; index < BUFF_SIZE; index++) {  
        shared.buf[index] = -1;
    }


    for (index = 0; index < NP; index++) {  
        /* Create a new producer */
        pthread_create(&idP, NULL, Producer, (void*)index);
    }

    for (index = 0; index < NC; index++) {  
        /* Create a new producer */
        pthread_create(&idC, NULL, Consumer, (void*)index);
    }

    /* Insert code here to create NC consumers */
    pthread_exit(NULL);
}

#include <stdio.h>
#include <pthread.h>

void* threadFunc(void* arg) {
    printf("Hello from thread!\n");
    return NULL;
}

int main() {
    pthread_t thread;
    pthread_create(&thread, NULL, threadFunc, NULL);
    pthread_join(thread, NULL);
    return 0;
}

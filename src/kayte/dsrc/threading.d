module kaytec.Threading;

import core.stdc.stdio : printf;
import core.sys.posix.pthread;
import core.stdc.stdlib : malloc, free;

extern(C) void* threadFunc(void* arg) {
    printf("Hello from thread!\n");
    return null;
}

void main() {
    pthread_t thread;

    // Create a new thread that will run threadFunc
    int result = pthread_create(&thread, null, &threadFunc, null);
    if (result != 0) {
        printf("Error creating thread\n");
        return;
    }

    // Wait for the thread to finish execution
    pthread_join(thread, null);
}

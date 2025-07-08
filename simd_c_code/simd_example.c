#include <stdio.h>
#include <stdlib.h>

#define SIZE 1024

void add_arrays(float *a, float *b, float *result) {
    for (int i = 0; i < SIZE; ++i) {
        result[i] = a[i] + b[i];
    }
}

int main() {
    float *a = (float*)aligned_alloc(16, SIZE * sizeof(float));
    float *b = (float*)aligned_alloc(16, SIZE * sizeof(float));
    float *result = (float*)aligned_alloc(16, SIZE * sizeof(float));

    for (int i = 0; i < SIZE; ++i) {
        a[i] = i;
        b[i] = i * 2;
    }

    add_arrays(a, b, result);

    printf("result[100] = %f\n", result[100]);

    free(a);
    free(b);
    free(result);
    return 0;
}

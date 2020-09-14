#include <stdio.h>

#define N 2
#define M 2

__global__ void hello(){

  printf("Hello from block: %d, thread: %d\n", blockIdx.x, threadIdx.x);
}

int main(){

  hello<<< N, M >>>();
  cudaDeviceSynchronize();
}


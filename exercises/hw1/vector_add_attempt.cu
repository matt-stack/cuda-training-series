#define N 2048*2048
#define M 512

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

__global__ void vector_add(int *d_a, int *d_b, int *d_c, int n){
	int index = threadIdx.x + blockIdx.x * blockDim.x;
	if (index < n){
		d_c[index] = d_a[index] + d_b[index];	
	}
}

int main(){
	int *a, *b, *c; // host
	int *d_a, *d_b, *d_c; // device
	int size = sizeof(int) * N;
	srand (time(NULL));

	//alloc device copies
	cudaMalloc((void **) &d_a, size);
	cudaMalloc((void **) &d_b, size);
	cudaMalloc((void **) &d_c, size);

	//alloc host copies
	a = (int *)malloc(size);
	b = (int *)malloc(size);
	c = (int *)malloc(size);

	for (int i = 0; i < N; i ++){
		a[i] = rand() % 100;
		b[i] = rand() % 100;
	}

	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

	vector_add<<<(N + M-1)/M, M>>>(d_a, d_b, d_c, N);

	cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

	//for (int i = 0; i < N; i ++){
		printf("a[0] = %d \n b[0] = %d \n c[0] = %d \n", a[0], b[0], c[0]);
	//}
	

	free(a);
	free(b);
	free(c);
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
}

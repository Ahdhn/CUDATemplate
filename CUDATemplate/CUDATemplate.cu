#include <stdio.h>
#include <assert.h>
#include <cuda_runtime.h>


__global__ void testKernel()
{
    printf("\n I am thread %d", threadIdx.x);
}

int main(int argc, char **argv)
{     
    testKernel<<<1, 1>>>();
    cudaDeviceSynchronize();
    return EXIT_SUCCESS;
}


#include <cuda_runtime.h>
#include <stdio.h>

#include "CUDALib.h"



namespace detail {
__global__ void lib_kernel()
{
    printf("\n I am thread %d from lib_kernel\n", threadIdx.x);
}
}  // namespace detail

void CUDALib::run()
{
    detail::lib_kernel<<<1, 1>>>();   
}
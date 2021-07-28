find_package(CUDA REQUIRED)

if(NOT DEFINED CUDA_ARCHS)
	############################### Autodetect CUDA Arch #####################################################
	#Auto-detect cuda arch. Inspired by https://wagonhelm.github.io/articles/2018-03/detecting-cuda-capability-with-cmake
	# This will define and populates CUDA_ARCHS and put it in the cache 	
	set(cuda_arch_autodetect_file ${CMAKE_BINARY_DIR}/autodetect_cuda_archs.cu)		
	file(WRITE ${cuda_arch_autodetect_file} [[
		#include <stdio.h>
		int main() {
		int count = 0; 
		if (cudaSuccess != cudaGetDeviceCount(&count)) { return -1; }
		if (count == 0) { return -1; }
		for (int device = 0; device < count; ++device) {
			cudaDeviceProp prop; 
			bool is_unique = true; 
			if (cudaSuccess == cudaGetDeviceProperties(&prop, device)) {
				for (int device_1 = device - 1; device_1 >= 0; --device_1) {
					cudaDeviceProp prop_1; 
					if (cudaSuccess == cudaGetDeviceProperties(&prop_1, device_1)) {
						if (prop.major == prop_1.major && prop.minor == prop_1.minor) {
							is_unique = false; 
							break; 
						}
					}
					else { return -1; }
				}
				if (is_unique) {
					fprintf(stderr, "--generate-code=arch=compute_%d%d,code=sm_%d%d;", prop.major, prop.minor, prop.major, prop.minor);
				}
			}
			else { return -1; }
		}
		return 0; 
		}
		]])
	
	set(cuda_detect_cmd  "${CUDA_NVCC_EXECUTABLE} -ccbin ${CMAKE_CXX_COMPILER} --run ${cuda_arch_autodetect_file}")
    message(STATUS "Executing: ${cuda_detect_cmd}")
	execute_process(COMMAND "${CUDA_NVCC_EXECUTABLE}" "-ccbin" "${CMAKE_CXX_COMPILER}" "--run" "${cuda_arch_autodetect_file}"
					#WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/CMakeFiles/"	
					RESULT_VARIABLE CUDA_RETURN_CODE	
					OUTPUT_VARIABLE dummy
					ERROR_VARIABLE fprintf_output					
					OUTPUT_STRIP_TRAILING_WHITESPACE)							
	if(CUDA_RETURN_CODE EQUAL 0)			
		set(CUDA_ARCHS ${fprintf_output} CACHE STRING "CUDA Arch")			
	else()
		message(STATUS "GPU architectures auto-detect failed. Will build for all possible architectures.")      
		set(CUDA_ARCHS --generate-code=arch=compute_35,code=sm_35
					   --generate-code=arch=compute_37,code=sm_37					   
					   --generate-code=arch=compute_50,code=sm_50
					   --generate-code=arch=compute_52,code=sm_52
					   --generate-code=arch=compute_60,code=sm_60
					   --generate-code=arch=compute_61,code=sm_61
					   --generate-code=arch=compute_70,code=sm_70
					   --generate-code=arch=compute_72,code=sm_72
					   --generate-code=arch=compute_75,code=sm_75
					   --generate-code=arch=compute_80,code=sm_80
					   --generate-code=arch=compute_86,code=sm_86
					   CACHE STRING "CUDA Arch")			
	endif()  	
	message(STATUS "CUDA_ARCHS=" ${CUDA_ARCHS})	
endif()
###################################################################################

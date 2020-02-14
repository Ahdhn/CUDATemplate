
cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

cmake_policy(SET CMP0077 OLD)

set(PROJECT_NAME "CUDATemplate")
project(${PROJECT_NAME} LANGUAGES CXX CUDA)  

#default build type is Release
if (CMAKE_BUILD_TYPE STREQUAL "")
    set(CMAKE_BUILD_TYPE Release)
endif ()

SET(CUDA_SEPARABLE_COMPILATION ON)


find_package(CUDA REQUIRED)
include_directories("${CUDA_INCLUDE_DIRS}")
include("cmake/AutoDetectCudaArch.cmake")
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -lineinfo; -std=c++14; -expt-extended-lambda; -O3; -use_fast_math; -rdc=true)
#set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -Xptxas -v; -G)

message(STATUS "CUDA_NVCC_FLAGS= " ${CUDA_NVCC_FLAGS})
message(STATUS "CMAKE_CUDA_FLAGS= " ${CMAKE_CUDA_FLAGS})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64 -Wall -std=c++14")

if(MSVC)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_SCL_SECURE_NO_WARNINGS")
endif()



set(CMAKE_INCLUDE_CURRENT_DIR ON)
set( MY_DIRECTORY "../CUDATemplate" )
file(GLOB_RECURSE MY_SRC ${MY_DIRECTORY}/CUDATemplate/*.*)
source_group(TREE ${MY_DIRECTORY} FILES ${MY_SRC})

if (MSVC)
	add_executable(${PROJECT_NAME} "${MY_SRC}")
else()
	CUDA_ADD_EXECUTABLE(${PROJECT_NAME} "${MY_SRC}")
endif()


###

target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_14)


set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE  ON)


set_target_properties(${PROJECT_NAME} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

target_link_libraries(${PROJECT_NAME} ${CUDA_LIBRARIES} cuda)

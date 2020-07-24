#CMake minimum requirement 
cmake_minimum_required(VERSION 3.15 FATAL_ERROR)

#Project name 
set(PROJECT_NAME "CUDATemplate")#<--- 
project(${PROJECT_NAME} LANGUAGES CXX CUDA)  

#default build type is Release
if (CMAKE_BUILD_TYPE STREQUAL "")
    set(CMAKE_BUILD_TYPE Release)
endif ()


# Direct all output to /bin directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin)


#Executable
add_executable(${PROJECT_NAME})
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_14)
target_include_directories(${PROJECT_NAME}    
    PRIVATE ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
)

#GLOB source files 
file(GLOB_RECURSE SrcFiles ${CMAKE_SOURCE_DIR}/CUDATemplate/*.*)#<---


#Pass the source files to the executable 
target_sources( ${PROJECT_NAME} 
    PRIVATE ${SrcFiles}
)


# Auto-detect GPU architecture, sets ${CUDA_ARCHS}
include("cmake/AutoDetectCudaArch.cmake")


# CUDA and C++ compiler flags
set(cxx_flags -m64 -Wall -std=c++14 $<$<STREQUAL:${MSVC},1>:-D_SCL_SECURE_NO_WARNINGS>	)
set(cuda_flags
    -Xcompiler=-Wall
    -Xcudafe=--display_error_number
    ${CUDA_ARCHS}
	-lineinfo	
	--expt-extended-lambda	
	-use_fast_math	
	#-Xptxas -warn-spills -res-usage #-v
	$<$<STREQUAL:${MSVC},0>:-O3>
    #-G	
)
add_library(developer_flags INTERFACE)
target_compile_options(developer_flags INTERFACE
    $<$<COMPILE_LANGUAGE:CXX>:${cxx_flags}>
    $<$<COMPILE_LANGUAGE:CUDA>:${cuda_flags}>
)

#Pass the flags to the executable
target_link_libraries( ${PROJECT_NAME}   
	PRIVATE $<BUILD_INTERFACE:developer_flags>	
)
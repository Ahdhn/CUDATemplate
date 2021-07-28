#CMake minimum requirement 
cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

#Project name 
set(PROJECT_NAME "CUDATemplate")#<TODO> change this to the name of your project 
project(${PROJECT_NAME} LANGUAGES CXX CUDA)  

if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.18)
  cmake_policy(SET CMP0104 OLD)
endif()

#default build type is Release
if (CMAKE_BUILD_TYPE STREQUAL "")
    set(CMAKE_BUILD_TYPE Release)
endif ()


# Direct all output to /bin directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin)


include(FetchContent)
# GoogleTest
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_Declare(googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        eaf9a3fd77869cf95befb87455a2e2a2e85044ff
)
FetchContent_MakeAvailable(googletest)
include(GoogleTest)

#Executable
add_executable(${PROJECT_NAME})
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)
target_include_directories(${PROJECT_NAME}    
    PRIVATE ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
)

#GLOB source files 
file(GLOB_RECURSE SrcFiles ${CMAKE_SOURCE_DIR}/CUDATemplate/*.*)#<TODO> change this to add your files 


#Pass the source files to the executable 
target_sources( ${PROJECT_NAME} 
    PRIVATE ${SrcFiles}
)


# Auto-detect GPU architecture, sets ${CUDA_ARCHS}
include("cmake/AutoDetectCudaArch.cmake")


# CUDA and C++ compiler flags
set(cxx_flags 
	$<$<CXX_COMPILER_ID:MSVC>:-D_SCL_SECURE_NO_WARNINGS /openmp /std:c++17> #<TODO> Add MSVC-specific compiler flags here
	$<$<CXX_COMPILER_ID:GNU>:-Wall -m64 -fopenmp -O3 -std=c++17>            #<TODO> Add GCC/Clang-specific compiler flags here
	)

set(cuda_flags
    -Xcompiler=$<$<CXX_COMPILER_ID:GNU>:-Wall -fopenmp -O3>
    -Xcudafe=--display_error_number
    ${CUDA_ARCHS}
	-lineinfo	
	--expt-extended-lambda	
	-use_fast_math	
	#-Xptxas -warn-spills -res-usage #-v
    $<$<CXX_COMPILER_ID:GNU>:-O3>	
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
	PRIVATE gtest_main
)

#OpenMP
find_package(OpenMP)
if(OpenMP_CXX_FOUND)
    target_link_libraries(${PROJECT_NAME} PUBLIC OpenMP::OpenMP_CXX)
endif()

enable_testing()
gtest_discover_tests(${PROJECT_NAME})
#CMake minimum requirement 
cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

set(exec_name "CUDAExec")

#GLOB source files 
file(GLOB_RECURSE src_files ${CMAKE_CURRENT_SOURCE_DIR}/include/*.*)#<TODO> change this to add your files 

#Executable
add_executable(${exec_name})
target_compile_features(${exec_name} PRIVATE cxx_std_17)

#Pass the source files to the executable 
target_sources( ${exec_name} PRIVATE ${src_files})

#Pass the flags to the executable
target_link_libraries( ${exec_name}   
	PRIVATE $<BUILD_INTERFACE:developer_flags>	
	PRIVATE gtest_main
)

gtest_discover_tests(${exec_name})
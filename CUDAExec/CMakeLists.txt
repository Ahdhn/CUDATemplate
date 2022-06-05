#CMake minimum requirement 
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)

set(exec_name "CUDAExec")

#GLOB source files 
file(GLOB_RECURSE src_files ${CMAKE_CURRENT_SOURCE_DIR}/include/*.*)#<TODO> change this to add your files 

#Executable
add_executable(${exec_name} ${src_files})

#Libs linked to the executable
target_link_libraries( ${exec_name}   
	CUDALib
	$<BUILD_INTERFACE:developer_flags>	
	gtest_main
)

#gtest_discover_tests(${exec_name})

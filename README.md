# CUDATemplate
My template for starting a new CUDA project using CMake on Windows (Visual Studio) or Linux (gcc, clang). The template also includes minimal YAML scripts for CI using Github Actions on both Windows (Visual Studio 2019) and Linux (Ubuntu). 


## Build 
You might first need to change the project name in the `CMakeLists.txt` and the folder name and fill in any `TODO`. Then simply run 

```
mkdir build
cd build 
cmake ..
```

Depending on the system, this will generate either a `.sln` project on Windows or a `make` file for a Linux system. 

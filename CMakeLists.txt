cmake_minimum_required(VERSION 3.16)

set(ZCCTARGET cpm)

project(idetest C)

# Avoid passing debug flags to the compile step (zcc maps Debug to -debug which
# breaks SDCC's compile pipeline). Keep debug info at link time only.
set(CMAKE_C_FLAGS_DEBUG "")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "-debug")

# Include per-target rules  
include(cmake/targets/asm.cmake)
include(cmake/targets/testfunc.cmake)
include(cmake/targets/idetest.cmake)



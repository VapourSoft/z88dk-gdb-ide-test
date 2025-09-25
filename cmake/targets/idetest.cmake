add_executable(idetest ./src/c-idetest/idetest.c)

# Detect if SDCC backend is available (z88dk-zsdcc sits next to zcc)
# get_filename_component(_Z88DK_BIN_DIR "${CMAKE_C_COMPILER}" DIRECTORY)
# set(_ZSDCC_PATH "${_Z88DK_BIN_DIR}/z88dk-zsdcc")

list(APPEND _IDETEST_COMPILE_OPTS --list --c-code-in-asm -compiler=sdcc -clib=sdcc_ix )

target_compile_options(idetest PUBLIC ${_IDETEST_COMPILE_OPTS})
target_link_libraries(idetest PUBLIC -lndos)
## Debug info now controlled globally via CMAKE_EXE_LINKER_FLAGS_DEBUG

 
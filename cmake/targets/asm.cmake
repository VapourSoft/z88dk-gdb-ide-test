file(GLOB ASM_SRCS "${CMAKE_CURRENT_SOURCE_DIR}/src/asm-idetest/*.asm")
set(ASM_OBJS)
set(ASM_LSTS)
foreach(_asm_file IN LISTS ASM_SRCS)
    get_filename_component(_asm_name ${_asm_file} NAME_WE)
    set(_asm_obj ${CMAKE_CURRENT_BINARY_DIR}/${_asm_name}.o)
    set(_asm_src_lis ${_asm_file}.lis)
    set(_asm_build_lst ${CMAKE_CURRENT_BINARY_DIR}/${_asm_name}.lst)

    add_custom_command(
        OUTPUT ${_asm_obj} ${_asm_src_lis}
        COMMAND /bin/sh -c "mkdir -p '${CMAKE_CURRENT_BINARY_DIR}/tmp' && TMPDIR='${CMAKE_CURRENT_BINARY_DIR}/tmp' ${CMAKE_C_COMPILER} +${ZCCTARGET} -c -debug --list '${_asm_file}' -o '${_asm_obj}'; rm -f '${_asm_obj}.sym' || true; rm -rf '${CMAKE_CURRENT_BINARY_DIR}/tmp'"
        DEPENDS ${_asm_file}
        COMMENT "Assembling ${_asm_file} -> ${_asm_obj} (and generating ${_asm_src_lis})"
        VERBATIM)

    list(APPEND ASM_OBJS ${_asm_obj})
    list(APPEND ASM_LSTS ${_asm_src_lis})
endforeach()

# Single custom target that builds all asm objects and listings
add_custom_target(asmobj DEPENDS ${ASM_OBJS} ${ASM_LSTS})

# Ensure generator "clean" removes z88dk side-effect files produced for each asm
# file. This populates the Makefile's clean rule (for Makefile generators)
# with these filenames so `cmake --build build --target clean` removes them.
set(CLEAN_FILES)
foreach(_asm_file IN LISTS ASM_SRCS)
    get_filename_component(_asm_name ${_asm_file} NAME_WE)
    list(APPEND CLEAN_FILES
        ${CMAKE_CURRENT_BINARY_DIR}/${_asm_name}.bin
        ${CMAKE_CURRENT_BINARY_DIR}/${_asm_name}.map
        ${CMAKE_CURRENT_BINARY_DIR}/${_asm_name}.sym
        ${CMAKE_CURRENT_BINARY_DIR}/${_asm_name}.lst
    )
endforeach()

if(CLEAN_FILES)
  set_property(DIRECTORY PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "${CLEAN_FILES}")
endif()

set(ASM_SRC ${ASM_SRCS})

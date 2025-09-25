set(TESTBIN ${CMAKE_CURRENT_BINARY_DIR}/testfunc.bin)
set(TESTMAP ${CMAKE_CURRENT_BINARY_DIR}/testfunc.map)
set(TESTSYM ${CMAKE_CURRENT_BINARY_DIR}/testfunc.sym)

add_custom_command(
    OUTPUT ${TESTBIN} ${TESTMAP} ${TESTSYM}
    COMMAND ${CMAKE_C_COMPILER} +${ZCCTARGET} -debug -m -s ${CMAKE_CURRENT_BINARY_DIR}/testfunc.o -o ${TESTBIN} -lndos
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/testfunc.o
    COMMENT "Linking ${CMAKE_CURRENT_BINARY_DIR}/testfunc.o -> ${TESTBIN}"
    VERBATIM)

add_custom_target(testfunc ALL DEPENDS ${TESTBIN})

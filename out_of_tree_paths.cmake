macro(resolve_path_for WHAT)
    if (DEFINED OUT_OF_TREE_${WHAT})
        if (OUT_OF_TREE_${WHAT})
            set(${WHAT}_ROOT ${CMAKE_CURRENT_LIST_DIR}/..)
            message(STATUS "Out of tree ${WHAT}_ROOT found: '${${WHAT}_ROOT}'")
        endif()
    endif()
endmacro()

resolve_path_for(SOC)
resolve_path_for(BOARD)
resolve_path_for(DTS)

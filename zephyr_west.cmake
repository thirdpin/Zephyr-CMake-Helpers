cmake_minimum_required(VERSION 3.20)

macro(find_zephyr_west_config)

set(CMAKE_CURRENT_SOURCE_DIR_iterate "${CMAKE_CURRENT_SOURCE_DIR}")
while(CMAKE_CURRENT_SOURCE_DIR_iterate)
    if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR_iterate}/.west/config)
        message(STATUS "Found west workspace: \"${CMAKE_CURRENT_SOURCE_DIR_iterate}\"")
        set (ZEPHYR_MANIFEST_DIR ${CMAKE_CURRENT_SOURCE_DIR_iterate})
        break()
    else()
        cmake_path(GET CMAKE_CURRENT_SOURCE_DIR_iterate PARENT_PATH CMAKE_CURRENT_SOURCE_DIR_iterate)
    endif()
endwhile()

endmacro()
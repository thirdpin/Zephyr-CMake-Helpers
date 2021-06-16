cmake_minimum_required(VERSION 3.20)

# parse_zephyr_config
# -------------------
#
# Parse some west config fields and extract
# knowledge about a Zephyr path.
#
# Arguments:
#    WEST_CONFIG_FILE_PATH: abs path to .config file
#
# Returns:
#    CONFIG_ZEPHYR_BASE (string): abs path to zephyr or empty
#    CONFIG_ZEPHYR_BASE_PREFER_CONFIG (bool): prefer configfile path
#      over env variable or not
#
function(parse_zephyr_config
        # in
        WEST_CONFIG_FILE_PATH
        # out
        CONFIG_ZEPHYR_BASE CONFIG_ZEPHYR_BASE_PREFER_CONFIG
)

if (WEST_CONFIG_FILE_PATH)
    cmake_path(NORMAL_PATH WEST_CONFIG_FILE_PATH)

    # Assume that base of paths set in the manifest is a path without trailing .west/config part
    cmake_path(GET WEST_CONFIG_FILE_PATH PARENT_PATH PATH_BASE)
    cmake_path(GET PATH_BASE PARENT_PATH PATH_BASE)
    cmake_path(APPEND PATH_BASE ".west/config" OUTPUT_VARIABLE assume_check)
    cmake_path(COMPARE ${WEST_CONFIG_FILE_PATH} EQUAL ${assume_check} assumed_path_equal)
    if (NOT assumed_path_equal)
        message(FATAL_ERROR
        "Error in the logic of resolving the base path of paths set in the manifest file. "
        "Is the trailing part of the manifest file path is '.west/config'?")
    endif()

    file(READ ${WEST_CONFIG_FILE_PATH} WEST_CONFIG_FILE)
    
    set(CONFIG_ZEPHYR_BASE_ "")
    set(CONFIG_ZEPHYR_BASE_PREFER_CONFIG_ FALSE)

    string(REGEX MATCH "base = (\/?[^ \t\r\n]+)+" _ ${WEST_CONFIG_FILE})

    if (CMAKE_MATCH_1)
        get_filename_component(
            CONFIG_ZEPHYR_BASE_
            ${PATH_BASE}/${CMAKE_MATCH_1}
            ABSOLUTE)

        string(REGEX MATCH "base-prefer = ([a-z]+)" _ ${WEST_CONFIG_FILE})
        if (${CMAKE_MATCH_1} STREQUAL "configfile")
            set(CONFIG_ZEPHYR_BASE_PREFER_CONFIG_ TRUE)
        endif()
    endif()
else()
    message(FATAL_ERROR "WEST_CONFIG_FILE_PATH arg is required!")
endif()

set(${CONFIG_ZEPHYR_BASE} ${CONFIG_ZEPHYR_BASE_} PARENT_SCOPE)
set(${CONFIG_ZEPHYR_BASE_PREFER_CONFIG} ${CONFIG_ZEPHYR_BASE_PREFER_CONFIG_} PARENT_SCOPE)

endfunction()

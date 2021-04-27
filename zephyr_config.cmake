# Copyright (C) 2021 Third pin, LLC <https://thirdpin.io/>

# This file is part of CMake helpers.

# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.

# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public
# License along with this library.  If not, see <http://www.gnu.org/licenses/>.

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
    file(READ ${WEST_CONFIG_FILE_PATH} WEST_CONFIG_FILE)
    
    set(CONFIG_ZEPHYR_BASE_ "")
    set(CONFIG_ZEPHYR_BASE_PREFER_CONFIG_ FALSE)

    string(REGEX MATCH "base = (\/?[^ \t\r\n]+)+" _ ${WEST_CONFIG_FILE})

    if (CMAKE_MATCH_1)
        get_filename_component(
            CONFIG_ZEPHYR_BASE_
            ${CMAKE_SOURCE_DIR}/${CMAKE_MATCH_1}
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

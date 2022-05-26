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

include(${CMAKE_CURRENT_LIST_DIR}/zephyr_config.cmake)

# extract_zephyr_base_loc
# -----------------------
#
# Use knowlage about a path of Zephyr in West config,
# the env ``ZEPHYR_BASE`` variable and previously set
# the ZEPHYR_BASE_LOC CMake variable to extract the one
# true Zephyr location.
#
# Arguments:
#    WEST_CONFIG_FILE_ABS_PATH_ARG: abs path to .config file
#
# Returns:
#    ZEPHYR_BASE_LOC (string): path to Zephyr
#
macro(extract_zephyr_base_loc WEST_CONFIG_FILE_ABS_PATH_ARG)
    set(IS_FATAL_ERROR FALSE)

    # Macros arg is not a variable so we make it
    set(WEST_CONFIG_FILE_ABS_PATH ${WEST_CONFIG_FILE_ABS_PATH_ARG})

    # If config is provided we should parse it
    if (WEST_CONFIG_FILE_ABS_PATH)
        parse_zephyr_config(
            # in
            ${WEST_CONFIG_FILE_ABS_PATH} 
            # out
            CONFIG_ZEPHYR_BASE
            CONFIG_ZEPHYR_BASE_PREFER_CONFIG)
    endif()

    if (NOT DEFINED ZEPHYR_BASE_LOC)
        if (DEFINED CONFIG_ZEPHYR_BASE AND CONFIG_ZEPHYR_BASE)
            # If -DZEPHYR_BASE_LOC does not set the path
            # to Zephyr but config is provided let's set
            # it from west config
            if (CONFIG_ZEPHYR_BASE_PREFER_CONFIG)
                # If config sets itself as prefered way to get
                # path then set it as ZEPHYR_BASE_LOC
                set(ZEPHYR_BASE_LOC ${CONFIG_ZEPHYR_BASE})
            else()
                # Else we're just trying to get it from env
                if (ENV{ZEPHYR_BASE})
                    set(ZEPHYR_BASE_LOC $ENV{ZEPHYR_BASE})
                else()
                    set(IS_FATAL_ERROR TRUE)
                endif()
            endif()
        else()
            # Also ZEPHYR_BASE_LOC can be taken
            # from environment variable ZEPHYR_BASE
            if (DEFINED ENV{ZEPHYR_BASE)
                set(ZEPHYR_BASE_LOC $ENV{ZEPHYR_BASE})
            else()
                set(FATAL_ERROR TRUE)
            endif()
        endif()

        if (IS_FATAL_ERROR)
            message(FATAL_ERROR "WEST_CONFIG_FILE_ABS_PATH_ARG or ZEPHYR_BASE_LOC must be passed"
                                "or ENV{ZEPHYR_BASE} must be defined!")
        endif()
    endif()

    unset(IS_FATAL_ERROR)
endmacro()

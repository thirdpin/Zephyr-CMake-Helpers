# Copyright (C) 2021 Third pin, LLC <https://thirdpin.io/>

# This file is part of CMake helpers.

# This library is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.

# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
# details.

# You should have received a copy of the GNU Lesser General Public License along
# with this library.  If not, see <http://www.gnu.org/licenses/>.

cmake_minimum_required(VERSION 3.20)

include(zephyr_extra_modules)

if(NOT SKIP_CMAKE_HELPERS)
    include(${CMAKE_CURRENT_LIST_DIR}/details/zephyr_west.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/details/zephyr_loc.cmake)

    message(STATUS "CMake Helpers Initialization Start")
    list(APPEND CMAKE_MESSAGE_INDENT "  ")

    message(STATUS "ZEPHYR_BASE environment is set as \"$ENV{ZEPHYR_BASE}\"")

    find_zephyr_west_config()

    cmake_path(
        APPEND WEST_WORKSPACE_DIR ".west/config"
        OUTPUT_VARIABLE ZEPHYR_MANIFEST_PATH
    )

    message(STATUS "Check west manifest \"${ZEPHYR_MANIFEST_PATH}\" "
                   "for ZEPHYR_BASE overriding"
    )

    # Set correct ZEPHYR_BASE var if we call CMake directly without west meta-tool
    extract_zephyr_base_loc(${ZEPHYR_MANIFEST_PATH})

    cmake_path(
        COMPARE "$ENV{ZEPHYR_BASE}" EQUAL "${ZEPHYR_BASE_LOC}"
                IS_ZEPHYR_BASE_NOT_OVERRIDED
    )

    if(IS_ZEPHYR_BASE_NOT_OVERRIDED)
        message(STATUS "ZEPHYR_BASE was not overridden")
    else()
        # Force correct Zephyr path
        set(ENV{ZEPHYR_BASE} ${ZEPHYR_BASE_LOC})
        message(STATUS "ZEPHYR_BASE is overridded by west manifest "
                       "and was set as \"$ENV{ZEPHYR_BASE}\"."
        )
    endif()

    if(CMAKE_BUILD_TYPE)
        unset(CMAKE_BUILD_TYPE CACHE)
        message(STATUS "Reset preconfigured CMAKE_BUILD_TYPE. "
                       "Zephyr has to care about it itself"
        )
    endif()

    if(DEFINED APPLICATION_SOURCE_DIR)
        message(STATUS "Leave user defined APPLICATION_SOURCE_DIR "
                       "untouched: ${APPLICATION_SOURCE_DIR}"
        )
    else()
        # If this file was included from project root CMakeLists.txt then we
        # assume that we are building app from root. Overwise from application
        # root.
        if(${CMAKE_SOURCE_DIR} EQUAL ${CMAKE_CURRENT_SOURCE_DIR})
            set(BUILD_FROM_ROOT TRUE)
        endif()

        if(DEFINED BUILD_FROM_ROOT AND BUILD_FROM_ROOT)
            # We in root folder
            message(STATUS "Building from project root")
            set(APPLICATION_SOURCE_DIR
                "${CMAKE_SOURCE_DIR}/app"
                CACHE PATH "Application Source Directory"
            )
        else()
            # We already in `app` folder
            message(STATUS "Building from application root")
            set(APPLICATION_SOURCE_DIR
                "${CMAKE_SOURCE_DIR}"
                CACHE PATH "Application Source Directory"
            )
        endif()
        message(
            STATUS "APPLICATION_SOURCE_DIR is set to ${APPLICATION_SOURCE_DIR}"
        )
    endif()

    list(POP_BACK CMAKE_MESSAGE_INDENT)
    message(STATUS "CMake Helpers Initialization Finish")
endif()

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

# add_zephyr_extra_modules
# ------------------------
#
# Add all passed paths to ZEPHYR_EXTRA_MODULES
#
# Arguments:
#    PATHS: relaive paths to the modules
#    MODULES_ROOT: abs path dirirectory with modules. Optional, by
#       default APPLICATION_SOURCE_DIR is used.
#
macro(add_zephyr_extra_modules)

    set(one_value_args MODULES_ROOT)
    set(multi_value_args PATHS)

    cmake_parse_arguments(
        _ZEM_ARG
        ""
        "${one_value_args}"
        "${multi_value_args}"
        ${ARGN}
    )

    # Set root path if exists
    if(DEFINED _ZEM_ARG_MODULES_ROOT)
        set(_ZEM_MODULES_ROOT_PATH "${_ZEM_ARG_MODULES_ROOT}")
    else()
        set(_ZEM_MODULES_ROOT_PATH "${APPLICATION_SOURCE_DIR}")
    endif()

    foreach(_ZEM_PATH IN LISTS _ZEM_ARG_PATHS)
        cmake_path(
            APPEND _ZEM_MODULES_ROOT_PATH ${_ZEM_PATH}
            OUTPUT_VARIABLE _ZEM_PATH_ABS
        )
        list(APPEND ZEPHYR_EXTRA_MODULES ${_ZEM_PATH_ABS})
    endforeach()

    list(JOIN _ZEM_ARG_PATHS ", " _ZEM_PRETTY_PATHS)
    message(STATUS "Add paths to ZEPHYR_EXTRA_MODULES: ${_ZEM_PRETTY_PATHS}")
endmacro()

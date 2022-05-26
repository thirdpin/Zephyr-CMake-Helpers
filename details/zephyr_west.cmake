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

cmake_minimum_required(VERSION 3.20)

# find_zephyr_west_config
# -------------------
#
# Finds West workspace path in parents directories
#
# Returns:
#    WEST_WORKSPACE_DIR (string): abs path to west workspace
#
macro(find_zephyr_west_config)

set(CMAKE_CURRENT_SOURCE_DIR_iterate "${CMAKE_CURRENT_SOURCE_DIR}")
while(CMAKE_CURRENT_SOURCE_DIR_iterate)
    if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR_iterate}/.west/config)
        message(STATUS "Found west workspace: \"${CMAKE_CURRENT_SOURCE_DIR_iterate}\"")
        set (WEST_WORKSPACE_DIR ${CMAKE_CURRENT_SOURCE_DIR_iterate})
        break()
    else()
        cmake_path(GET CMAKE_CURRENT_SOURCE_DIR_iterate PARENT_PATH CMAKE_CURRENT_SOURCE_DIR_iterate)
    endif()
endwhile()

endmacro()
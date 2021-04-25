/*
    Copyright (C) 2021 Third pin, LLC <https://thirdpin.io/>

    This file is part of CMake helpers.

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*/

# Extract version
include(${CMAKE_CURRENT_LIST_DIR}/zephyr_version.cmake)

# Resolve out of tree paths if any enabled
include(${CMAKE_CURRENT_LIST_DIR}/out_of_tree_paths.cmake)

# Setup Zephyr and its toolchains
if ($ZEPHYR_VERSION VERSION_GREATER_EQUAL "2.2.99")
    # This way is the most modern one
    # It requires to call `west zephyr-export` first
    find_package(Zephyr HINTS $ENV{ZEPHYR_BASE})
    if (not Zephyr_FOUND)
        message(FATAL_ERROR "Make `west zephyr-export` first!")
    endif()
else()
    # Old way to initialize Zephyr
    include($ENV{ZEPHYR_BASE}/cmake/app/boilerplate.cmake NO_POLICY_SCOPE)
endif()

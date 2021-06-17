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

if (DEFINED WEST_PYTHON)
  message(STATUS "Expected, is run by West tool. Skip Cmake Helpers initialization")
  set(SKIP_CMAKE_HELPERS 1)
else()
  set(SKIP_CMAKE_HELPERS 0)
endif()

if (NOT SKIP_CMAKE_HELPERS)
  message(STATUS "##### CMake Helpers Initialization start")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")

  message(STATUS "ZEPHYR_BASE environment is set as \"$ENV{ZEPHYR_BASE}\"")

  include(${CMAKE_CURRENT_LIST_DIR}/zephyr_west.cmake)
  find_zephyr_west_config()

  cmake_path(APPEND ZEPHYR_MANIFEST_DIR ".west/config" OUTPUT_VARIABLE ZEPHYR_MANIFEST_PATH)

  message(STATUS "Check west manifest \"${ZEPHYR_MANIFEST_PATH}\" for ZEPHYR_BASE overriding")

  # Set correct ZEPHYR_BASE var if we call CMake directly without west meta-tool
  include(${CMAKE_CURRENT_LIST_DIR}/zephyr_loc.cmake)
  extract_zephyr_base_loc(${ZEPHYR_MANIFEST_PATH})

  cmake_path(COMPARE "$ENV{ZEPHYR_BASE}" EQUAL "${ZEPHYR_BASE_LOC}" IS_ZEPHYR_BASE_NOT_OVERRIDED)
  if (IS_ZEPHYR_BASE_NOT_OVERRIDED)
    message(STATUS "ZEPHYR_BASE is not overridden")
  else()
    # Force correct Zephyr path
    set(ENV{ZEPHYR_BASE} ${ZEPHYR_BASE_LOC})
    message(STATUS "ZEPHYR_BASE is overridding by west manifest and is sets as \"$ENV{ZEPHYR_BASE}\".")
  endif()

  if (CMAKE_BUILD_TYPE)
    unset(CMAKE_BUILD_TYPE CACHE)
    message(STATUS "Reset preconfigured CMAKE_BUILD_TYPE. Zephyr has to care about it itself.")
  endif()

  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(STATUS "##### CMake Helpers Initialization finish")

endif()

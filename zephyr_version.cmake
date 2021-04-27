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

file(READ $ENV{ZEPHYR_BASE}/VERSION ZEPHYR_VERSION_FILE)

string(REGEX MATCH "VERSION_MAJOR = ([0-9]*)" _ ${ZEPHYR_VERSION_FILE})
set(ZEPHYR_VERSION_MAJOR ${CMAKE_MATCH_1})

string(REGEX MATCH "VERSION_MINOR = ([0-9]*)" _ ${ZEPHYR_VERSION_FILE})
set(ZEPHYR_VERSION_MINOR ${CMAKE_MATCH_1})

string(REGEX MATCH "PATCHLEVEL = ([0-9]*)" _ ${ZEPHYR_VERSION_FILE})
set(ZEPHYR_VERSION_PATCH ${CMAKE_MATCH_1})

set(ZEPHYR_VERSION ${ZEPHYR_VERSION_MAJOR}.${ZEPHYR_VERSION_MINOR}.${ZEPHYR_VERSION_PATCH})

message(STATUS "Zephyr ${ZEPHYR_VERSION} found")

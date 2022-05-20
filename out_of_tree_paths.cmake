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

macro(resolve_path_for WHAT)
  if(DEFINED OUT_OF_TREE_${WHAT})
    if(OUT_OF_TREE_${WHAT})
      if(DEFINED ${APPLICATION_SOURCE_DIR})
        set(${WHAT}_ROOT ${APPLICATION_SOURCE_DIR})
      else()
        set(${WHAT}_ROOT ${CMAKE_SOURCE_DIR})
      endif()
      message(STATUS "Out of tree ${WHAT}_ROOT found: '${${WHAT}_ROOT}'")
    endif()
  endif()
endmacro()

resolve_path_for(SOC)
resolve_path_for(BOARD)
resolve_path_for(DTS)

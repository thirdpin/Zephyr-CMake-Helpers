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
      if (${WHAT}_ROOT)
        list(APPEND ${WHAT}_ROOT ${APPLICATION_SOURCE_DIR})
        message(STATUS "Append existing ${WHAT}_ROOT with: '${APPLICATION_SOURCE_DIR}'")
        message(STATUS "${WHAT}_ROOT constaints now: '${${WHAT}_ROOT}'")
      else()
        set(${WHAT}_ROOT ${APPLICATION_SOURCE_DIR})
        message(STATUS "Set ${WHAT}_ROOT to: '${${WHAT}_ROOT}'")
      endif()
    endif()
  endif()
endmacro()

resolve_path_for(BOARD)

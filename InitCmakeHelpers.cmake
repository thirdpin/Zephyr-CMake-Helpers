cmake_minimum_required(VERSION 3.20)

if (DEFINED WEST_PYTHON)
  message(STATUS "Expected, is run by West tool. Skip Cmake Helpers initialization")
  set(SKIP_CMAKE_HALPERS 1)
else()
  set(SKIP_CMAKE_HALPERS 0)
endif()

if (NOT SKIP_CMAKE_HALPERS)
  message(STATUS "##### CMake Helpers Initialization start")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")

  if (APPLICATION_SOURCE_DIR)
    cmake_path(IS_RELATIVE APPLICATION_SOURCE_DIR APPLICATION_SOURCE_DIR_is_relative)
    if (APPLICATION_SOURCE_DIR_is_relative)
      set(APPLICATION_SOURCE_DIR_BASE "")
      cmake_path(SET APPLICATION_SOURCE_DIR NORMALIZE ${APPLICATION_SOURCE_DIR})
      cmake_path(SET CMAKE_CURRENT_SOURCE_DIR NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR})

      message(STATUS "Detected APPLICATION_SOURCE_DIR set as relative: \"${APPLICATION_SOURCE_DIR}\". "
      "Try to fine repository base")

      set(loop_guard 1)
      set(APPLICATION_SOURCE_DIR_tmp "${APPLICATION_SOURCE_DIR}")
      set(CMAKE_CURRENT_SOURCE_DIR_tmp "${CMAKE_CURRENT_SOURCE_DIR}")

      message(STATUS "##### Start finding repository base path")
      
      while(1)
        list(APPEND CMAKE_MESSAGE_INDENT "  [${loop_guard}] ")

        cmake_path(GET APPLICATION_SOURCE_DIR_tmp FILENAME APPLICATION_SOURCE_DIR_tmp_filename)
        cmake_path(GET CMAKE_CURRENT_SOURCE_DIR_tmp FILENAME CMAKE_CURRENT_SOURCE_DIR_tmp_filename)

        if (NOT "${APPLICATION_SOURCE_DIR_tmp_filename}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR_tmp_filename}")
          message(STATUS "Looks like found repository base: \"${CMAKE_CURRENT_SOURCE_DIR_tmp}\"")
          set(APPLICATION_SOURCE_DIR_BASE "${CMAKE_CURRENT_SOURCE_DIR_tmp}")
          set(set(APPLICATION_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR_tmp}))
          list(POP_BACK CMAKE_MESSAGE_INDENT)
          break()
        endif()

        message(STATUS "From paths \"${APPLICATION_SOURCE_DIR_tmp}\" and \"${CMAKE_CURRENT_SOURCE_DIR_tmp}\" "
        "trailing part is equal: \"${APPLICATION_SOURCE_DIR_tmp_filename}\" and \"${CMAKE_CURRENT_SOURCE_DIR_tmp_filename}\"")

        cmake_path(GET APPLICATION_SOURCE_DIR_tmp PARENT_PATH APPLICATION_SOURCE_DIR_tmp)
        cmake_path(GET CMAKE_CURRENT_SOURCE_DIR_tmp PARENT_PATH CMAKE_CURRENT_SOURCE_DIR_tmp)

        MATH(EXPR loop_guard "${loop_guard}+1")

        if (${loop_guard} GREATER 10)
          message(STATUS "Looks like finding is loped. Try continue with untouched APPLICATION_SOURCE_DIR")
          list(POP_BACK CMAKE_MESSAGE_INDENT)
          break()
        endif()

        list(POP_BACK CMAKE_MESSAGE_INDENT)
      endwhile()

      message(STATUS "##### Finish finding repository base path")

      if (APPLICATION_SOURCE_DIR_BASE)
        cmake_path(APPEND APPLICATION_SOURCE_DIR_BASE "${APPLICATION_SOURCE_DIR}" OUTPUT_VARIABLE APPLICATION_SOURCE_DIR)
        message(STATUS "Set APPLICATION_SOURCE_DIR explicite to relation of found base path: \"${APPLICATION_SOURCE_DIR}\"")
      endif()
    endif()
  endif()


  message(STATUS "ZEPHYR_BASE environment is set as \"$ENV{ZEPHYR_BASE}\"")

  # Set correct ZEPHYR_BASE var if we call CMake directly without west meta-tool
  include(${CMAKE_CURRENT_LIST_DIR}/zephyr_loc.cmake)

  include(${CMAKE_CURRENT_LIST_DIR}/zephyr_west.cmake)
  find_zephyr_west_config()

  cmake_path(APPEND ZEPHYR_MANIFEST_DIR ".west/config" OUTPUT_VARIABLE ZEPHYR_MANIFEST_PATH)

  message(STATUS "Check west manifest \"${ZEPHYR_MANIFEST_PATH}\" for ZEPHYR_BASE overriding")

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
    message(STATUS "Reseted preconfigured CMAKE_BUILD_TYPE. Zephyr has to care about it itself.")
  endif()

  list(POP_BACK CMAKE_MESSAGE_INDENT)
  message(STATUS "##### CMake Helpers Initialization finish")

endif()

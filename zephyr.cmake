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
file(READ $ENV{ZEPHYR_BASE}/VERSION ZEPHYR_VERSION_FILE)

string(REGEX MATCH "VERSION_MAJOR = ([0-9]*)" _ ${ZEPHYR_VERSION_FILE})
set(ZEPHYR_VERSION_MAJOR ${CMAKE_MATCH_1})

string(REGEX MATCH "VERSION_MINOR = ([0-9]*)" _ ${ZEPHYR_VERSION_FILE})
set(ZEPHYR_VERSION_MINOR ${CMAKE_MATCH_1})

string(REGEX MATCH "PATCHLEVEL = ([0-9]*)" _ ${ZEPHYR_VERSION_FILE})
set(ZEPHYR_VERSION_PATCH ${CMAKE_MATCH_1})

set(ZEPHYR_VERSION ${ZEPHYR_VERSION_MAJOR}.${ZEPHYR_VERSION_MINOR}.${ZEPHYR_VERSION_PATCH})

message(STATUS "Zephyr ${ZEPHYR_VERSION} found")
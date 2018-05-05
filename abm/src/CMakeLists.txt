cmake_minimum_required(VERSION 3.9.2)
project(abm)

include(CTest)

set (CMAKE_CXX_STANDARD 11)

## add include directories
include_directories("${PROJECT_BINARY_DIR}")

# add the executable
add_executable(dbgen main.cc)
install(TARGETS dbgen DESTINATION bin)

cmake_minimum_required(VERSION 3.2.0)
project(Aggregate-Benchmark)

include(CTest)

set (CMAKE_CXX_STANDARD 11)
set (CMAKE_CXX_STANDARD_REQUIRED ON)

## add include directories
include_directories("${PROJECT_BINARY_DIR}")

# add the executable
add_executable(dbgen main.cc)
install(TARGETS dbgen DESTINATION bin)

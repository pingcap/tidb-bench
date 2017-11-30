cmake_minimum_required(VERSION 3.0)
project(store_bench)

set(CMAKE_CXX_STANDARD 11)
set(SOURCE_FILES main.cpp)
add_executable(store_bench ${SOURCE_FILES})

find_library(ROCKSDB NAMES rocksdb)
find_library(GFLAGS NAMES gflags)
target_link_libraries(store_bench rocksdb pthread gflags)

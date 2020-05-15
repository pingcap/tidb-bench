### A Wrapper for RocksDB db_bench

#### Usage
1. compile rocksdb db_bench & put it in the same directory with rocksdb.cpp
2. modify the args in bench.arg
3. g++ -std=c++11 -O rocksdb.cpp -o rocksdb && ./rocksdb bench.arg `test_result_dir`

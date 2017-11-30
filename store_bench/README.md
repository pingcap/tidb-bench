## Build

1. Install rocksdb and gflags.
2. `cmake .`
3. `make`

## Example

# load 1 million records. 

`./store_bench -run=load -path=/tmp/store_benh -num=1000000 -threads=8`

# run random get 10000 times per thread with random range [0, 1000000) and 16 threads.

`./store_bench -run=get -num=1000000 -nop=10000 -threads=16`


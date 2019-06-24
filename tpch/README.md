TPC-H Benchmark, specific for TiDB only
## Introduction

This is ported from https://github.com/xinglin/tpch. But do a lot change to make it work easier when the scale factor fo TPC-H is large.
Also made some changes to make it work better with TiDB.

## How to use 

### Edit the `_env.sh`

It contains the TiDB ip, port info. Also the TPC-H scale factor is included.

### Build `dbgen` tool

`cd dbgen && make`

If you are using macOs, please replace `#include<malloc.h>` in `varsub.c` and `bm_utils.c` to `#include<stdlib.c>`.

### Generate dataset

You can use the `gen.sh` in `dbgen` directory. The command `bash gen.sh lineitem 16` means that generate the data for table lineitem and split the data to 16 files. After finished, you can use `ls lineitem*` to see the generated files:

```
ls lineitem*
lineitem.tbl.1   lineitem.tbl.11  lineitem.tbl.13  lineitem.tbl.15  lineitem.tbl.2  lineitem.tbl.4  lineitem.tbl.6  lineitem.tbl.8
lineitem.tbl.10  lineitem.tbl.12  lineitem.tbl.14  lineitem.tbl.16  lineitem.tbl.3  lineitem.tbl.5  lineitem.tbl.7  lineitem.tbl.9
```

You can put them to a seperate directory like `data/tpch${tpch_scale}` if you want to test multiple TPC-H workload.

### Load data to TiDB

Use the `load.sh` at the root directory to load data. Command `bash load.sh lineitem 16` means load data of lineitem which is separated into 16 files into TIDB

### Analyze Table and load stats into memory

Run analyze command to analyze all the tables.
And since the statistics of columns are loaded by need. We need to load them first before the running the benchmark. You can run the sql in `load_stats.sql` to do this.

### Run the benchmark

`go build` and then `./tpch -addr="..." -port=... -scale=...` to get the benchmark result. It runs each sql 3 times and use the average as the result.
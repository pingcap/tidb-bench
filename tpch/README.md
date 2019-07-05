TPC-H Benchmark, specific for MySQL/TiDB
## Introduction

This is ported from https://github.com/xinglin/tpch. But do a lot change to make it work easier when the scale factor fo TPC-H is large.
Also made some changes to make it work better with TiDB.

## How to use 

### Edit the `_env.sh`

It contains the TiDB ip, port info. Also the TPC-H scale factor is included.

### Build `dbgen` tool

`cd dbgen && make`

If you are using macOS, please replace `#include<malloc.h>` in `varsub.c` and `bm_utils.c` to `#include<stdlib.c>`.

### Generate dataset

You can use the `gen.sh` in `dbgen` directory. The command `./gen.sh lineitem 16` means that generate the data for table `lineitem` and split the data into 16 files. After finished, you can use `ls lineitem*` to see the generated files:

```
ls lineitem*
lineitem.tbl.1   lineitem.tbl.11  lineitem.tbl.13  lineitem.tbl.15  lineitem.tbl.2  lineitem.tbl.4  lineitem.tbl.6  lineitem.tbl.8
lineitem.tbl.10  lineitem.tbl.12  lineitem.tbl.14  lineitem.tbl.16  lineitem.tbl.3  lineitem.tbl.5  lineitem.tbl.7  lineitem.tbl.9
```

You can put them to a seperate directory like `data/tpch${tpch_scale}` if you want to test multiple TPC-H workload.

### Load data

Use the `load.sh` at the root directory to load data. Command `bash load.sh lineitem 16` means load data of lineitem which is separated into 16 files into TIDB

### Analyze Table and load stats into memory

Use `analyze.sh` to analyze all the tables. You can set `tidb_build_stats_concurrency` to a large value before analyzing tables.

The column statistics of tables are cached by need in the TiDB server. In order to get a better execution plan and query latency, it's recommended to run the SQL in `load_stats.sql`  to load the needed column statistics into the TiDB server before running the TPC-H benchmark.

After executing the SQL, please wait for `x * stats-lease / analyze-concurrency` seconds to let TiDB finish loading column statistics into the memory.

***NOTE*** that if you're loading to MySQL, you don't need to run sql in the `load_stats.sql`.

Also ***NOTE*** that if the TiDB server is restarted. You need to run the `load_stats.sql` again before you run the benchmark.

### Set the system variables.

You can view at our docs repo to see the full description of TiDB's system variables.

For testing, you can simply use `show variables like '%tidb%concurrency%'` to get the variables related with execution. You set these variables to the the number of you CPU cores.

***NOTE*** If you're using MySQL, you can skip this procedure.

### Run the benchmark

`go build` and then `./tpch -addr="..." -port=... -scale=...` to get the benchmark result. It runs each sql 3 times and use the average as the result.

TPC-H Benchmark, specific for MySQL/TiDB
## Introduction
file structure
  - alltable.load
	mysql commands to load all data
  - alltable.count
	mysql commands to select count(*) all tables
  - dss.sql
 	modified schema definition file
  - get-all-query-time.pl
 	perl script to get runtime of each query
  - get-query-time.pl
 	perl script to get runtime of a query
  - queries
	22 TPC-H queries
  - tablescanquery.pl
	perl script to generate scan query for all tables

Some changes have been made to official files provided by TPC-H, to make
them work with TiDB.

## How to use 

Use mysql client login to `TiDB` and create a databse call `tpch`.
`make tbl` will make `dbgen` and generate `*.tbl` files.

`make load` will create database and tables in TiDB and load all `*.tbl` into TiDB.

After this, please be patient. If you really want to know any progress that `TiDB` is
making right now, you can open another terminal and use query defined in `alltable.count`
to know how many rows in the table.

If you are using macOs, please replace `#include<malloc.h>` in `varsub.c` and `bm_utils.c` to `#include<stdlib.c>`.

## How to use in Tiflash, using tidb-lighting to fast load data

step 1: `make dbgen`: make executable file of dbgen

step 2: `sh gen_load_tiflash.sh 1 ./dss_tiflash.sql` generate data of a specific scale factor and create a database and create schema. The first parameter means the scale factor, and the second is the ddl sql. **You MUST set the right scale factor of data, and the database IP and Port in gen_load_tiflash.sh.** 

step3: update `data-source-dir ` in `tidb-lightning.toml`, use it and `tikv-importer.toml` to fast load data. Update the IP and Port of these two files.
  

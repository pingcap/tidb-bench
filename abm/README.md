# ABM(Aggregate Benchmark)

## Introduction

- [What is ABM](./docs/docs.md)

## How To Use

### 1. Build `dbgen`

We use cmake to build this project:
```sh
mkdir build
cd build
cmake ../src
make
```

You can even `install` this binary:
```sh
# after make
make install
```

### 2. Generate Data

After building the `dbgen` binary:
```sh
mkdir csv
cd csv
../build/dbgen -s 1
```

### 3. Create Database && Tables
```sh
mysql -h 127.0.0.1 -P 4000 -u root -e "drop database if exists abm"
mysql -h 127.0.0.1 -P 4000 -u root -e "create database abm"
mysql -h 127.0.0.1 -P 4000 -u root -D abm < scripts/create_table.sql
```

### 4. Load Data
```sh
cd csv
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't0.tbl'   into table t0_0     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't2.tbl'   into table t2_0     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't4.tbl'   into table t4_0     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't6.tbl'   into table t6_0     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't8.tbl'   into table t8_0     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't10.tbl'  into table t10_0    fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't12.tbl'  into table t12_0    fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 'full.tbl' into table full_0   fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't0.tbl'   into table t0_1     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't2.tbl'   into table t2_1     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't4.tbl'   into table t4_1     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't6.tbl'   into table t6_1     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't8.tbl'   into table t8_1     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't10.tbl'  into table t10_1    fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't12.tbl'  into table t12_1    fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 'full.tbl' into table full_1   fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't0.tbl'   into table t0_2     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't2.tbl'   into table t2_2     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't4.tbl'   into table t4_2     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't6.tbl'   into table t6_2     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't8.tbl'   into table t8_2     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't10.tbl'  into table t10_2    fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't12.tbl'  into table t12_2    fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 'full.tbl' into table full_2   fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't0.tbl'   into table t0_3     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't2.tbl'   into table t2_3     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't4.tbl'   into table t4_3     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't6.tbl'   into table t6_3     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't8.tbl'   into table t8_3     fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't10.tbl'  into table t10_3    fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 't12.tbl'  into table t12_3    fields terminated by '|' lines terminated by '\n'" &
mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D abm -e "load data local infile 'full.tbl' into table full_3   fields terminated by '|' lines terminated by '\n'" &
```

NOTE: for step 3 and 4, here is a shell scripts located in [scripts/load\_data.sh](./scripts/load_data.sh) to help.

### 5. Generate Queries

Since there are 300+ queries provided in this benchmark, many of them share the same prototype, we provide a python script to help us generate all the queries, for more detail, please refer to [ABM Queries](./queries/README.md) for more detail.

```sh
cd queries
./gen_queries.py
```

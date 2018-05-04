# TiAggregate

Benchmarks for aggregate functions.

## Introduction

- [简体中文](./docs/cn.md)

## How To Use

### 1. Build
```sh
cd src
g++ main.cc -o dbgen -std=c++11
cd -
```

### 2. Generate Data
```sh
cd src
./dbgen
```

### 3. Create Database && Tables
```sh
mysql -h $host -P $port -u $user -e "drop database if exists $database"
mysql -h $host -P $port -u $user -e "create database $database"
mysql -h $host -P $port -u $user -D $database < create_table.sql
```

### 4. Load Data
```sh
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't0.tbl'   into table t0_0     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't2.tbl'   into table t2_0     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't4.tbl'   into table t4_0     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't6.tbl'   into table t6_0     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't8.tbl'   into table t8_0     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't10.tbl'  into table t10_0    fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't12.tbl'  into table t12_0    fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 'full.tbl' into table full_0   fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't0.tbl'   into table t0_1     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't2.tbl'   into table t2_1     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't4.tbl'   into table t4_1     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't6.tbl'   into table t6_1     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't8.tbl'   into table t8_1     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't10.tbl'  into table t10_1    fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't12.tbl'  into table t12_1    fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 'full.tbl' into table full_1   fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't0.tbl'   into table t0_2     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't2.tbl'   into table t2_2     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't4.tbl'   into table t4_2     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't6.tbl'   into table t6_2     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't8.tbl'   into table t8_2     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't10.tbl'  into table t10_2    fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't12.tbl'  into table t12_2    fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 'full.tbl' into table full_2   fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't0.tbl'   into table t0_3     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't2.tbl'   into table t2_3     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't4.tbl'   into table t4_3     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't6.tbl'   into table t6_3     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't8.tbl'   into table t8_3     fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't10.tbl'  into table t10_3    fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 't12.tbl'  into table t12_3    fields terminated by '|' lines terminated by '\n'" &
mysql -h $host -P $port -u $user --local-infile=1 -D $database -e "load data local infile 'full.tbl' into table full_3   fields terminated by '|' lines terminated by '\n'" &
```

### 5. Fire A Query

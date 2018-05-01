# Star Schema Benchmark

## Introduction

[dbgen](./dbgen) comes from [electrum/ssb-dbgen](https://github.com/electrum/ssb-dbgen), thanks to [electrum](https://github.com/electrum)

[Star Schema Benchmark](https://www.cs.umb.edu/~poneil/StarSchemaB.PDF)

## Build

```sh
cd dbgen
make -j8
cd ..
```

## Data generation

```sh
cd dbgen
# "-s" is used to specify the volume of data to generate in GB.
# "-T a" indicates dbgen to generate data for all tables.
./dbgen -s 1 -T a
cd ..
```

## DataBase and Table schema generation
```sh
mysql -h 127.0.0.1 -P 4000 -u root -e "drop database if exists ssb;"
mysql -h 127.0.0.1 -P 4000 -u root -e "create database ssb;"
mysql -h 127.0.0.1 -P 4000 -u root -D ssb < ddl.sql
```

## Load Data

```sh
mysql -u 127.0.0.1 -P 4000 -u root -D ssb -e "load data local infile 'SSB/part.tbl'      into table part      fields terminated by '|' lines terminated by '\n';"
mysql -u 127.0.0.1 -P 4000 -u root -D ssb -e "load data local infile 'SSB/supplier.tbl'  into table supplier  fields terminated by '|' lines terminated by '\n';"
mysql -u 127.0.0.1 -P 4000 -u root -D ssb -e "load data local infile 'SSB/customer.tbl'  into table customer  fields terminated by '|' lines terminated by '\n';"
mysql -u 127.0.0.1 -P 4000 -u root -D ssb -e "load data local infile 'SSB/date.tbl'      into table date      fields terminated by '|' lines terminated by '\n';"
mysql -u 127.0.0.1 -P 4000 -u root -D ssb -e "load data local infile 'SSB/lineorder.tbl' into table lineorder fields terminated by '|' lines terminated by '\n';"
```

## Run Queries

There are 13 queries in the star schema benchmark, located in [queries](./queries)

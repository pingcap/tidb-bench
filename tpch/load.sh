#!/bin/bash

table="$1"
blocks="$2"
check="$3"
data="./data"


set -eux
set -o pipefail

source ./_env.sh

if [ -z "$table" ]; then
    echo "usage: <bin> table-name [blocks-number=1]" >&2
    exit 1
fi

if [ -z "$blocks" ]; then
    blocks="1"
fi

mysql -h $tidb_host -P $tidb_port -uroot -e "create database if not exists tpch${tpch_scale};"
mysql -h $tidb_host -P $tidb_port -uroot -D tpch${tpch_scale} < dss.sql

if [ "$blocks" == "1" ]; then
    file="$data/tpch${tpch_scale}/$table.tbl"
    echo mysql -h $tidb_host -P $tidb_port -u root -D tpch${tpch_scale} \
        -e "load data local infile '$file' into table $table fields terminated by '|' lines terminated by '|\n';"
else
    for ((i=1; i<$blocks+1; ++i)); do
        file="$data/tpch${tpch_scale}/$table.tbl.$i"
        mysql -h $tidb_host -P $tidb_port -u root -D tpch${tpch_scale} \
            -e "load data local infile '$file' into table $table fields terminated by '|' lines terminated by '|\n';" &
    done
    wait
fi

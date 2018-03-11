#!/bin/bash
set -eu

HOST="127.0.0.1"
PORT="3306"
USER="root"
PASSWD="12345678"
DATABASE="TPCDS10"
SCALE="1"
LOG_FILE="load_data.log"

## build tools
build_tool()
{
    cd tools && make -j8 && cd -
}

## generate data
generate_data()
{
    cd tools && ./dsdgen -sc $SCALE -f && cd -
}

## create database
create_database()
{
    mysql -h $HOST -P $PORT -u $USER -p$PASSWD -D test -e "drop database if exists $DATABASE;"
    mysql -h $HOST -P $PORT -u $USER -p$PASSWD -D test -e "create database $DATABASE;"
    mysql -h $HOST -P $PORT -u $USER -p$PASSWD -D $DATABASE < tools/tpcds.sql
}

## create load data sql files
load_data()
{
    rm -rf $LOG_FILE
    touch $LOG_FILE
    for file_name in `ls tools/*.dat`; do
        table_file=$(echo "${file_name##*/}")
        table_name=$(echo "${table_file%.*}" | tr '[:upper:]' '[:lower:]')
        load_data_sql="LOAD DATA LOCAL INFILE '$file_name' INTO TABLE $table_name FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';"
        mysql -h $HOST -P $PORT -u $USER --local-infile=1 -p$PASSWD -D $DATABASE -e "$load_data_sql" >> $LOG_FILE 2>&1 &
    done
}

build_tool
generate_data
create_database
load_data

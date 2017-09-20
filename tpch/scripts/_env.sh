#!/bin/bash
source _helper.sh

export MYSQL_BIN="mysql -h 127.0.0.1 -P 4000 -u root"
export CURRENT_DIR=$PWD
export DB_PREFIX="tpch"
export TPCH_SCALE="1"
export TPCH_BLOCKS="10"
export TPCH_STEP="2"
export META_DIR="$CURRENT_DIR/meta"
export DATABASE="$DB_PREFIX$TPCH_SCALE"
export DBGEN_RESULT_DIR_PREFIX="$CURRENT_DIR"/"$DB_PREFIX"-"$TPCH_SCALE"



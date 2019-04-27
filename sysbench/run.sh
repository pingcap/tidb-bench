#!/bin/bash

if [[ $# -ne 3 ]]
then
  echo "usage: run.sh [test name] [prepare/run/help] [threads]"
  echo "       e.g. run.sh point_select prepare 16"
  exit 1
fi

sysbench --config-file=config --threads=$3 oltp_$1 --tables=1 --table_size=1 $2 > $1_$2_$3.log 2>&1

#!/bin/bash

set -x

source ./conf.sh

# run
sysbench --test=./lua-tests/db/oltp.lua --mysql-host=${host} --mysql-port=${port} \
  --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
  --oltp-tables-count=${tcount} --oltp-table-size=${tsize} \
  --num-threads=${threads} --max-requests=${requests} \
  --oltp-read-only=off --report-interval=${interval} --rand-type=uniform \
  --max-time=${maxtime} --percentile=95 run

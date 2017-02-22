#!/bin/bash

set -x

source ./conf.sh

sysbench --test=./lua-tests/db/delete.lua --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --oltp-tables-count=${tcount} \
 --oltp-table-size=${tsize} --num-threads=${threads} --report-interval=60 \
 --max-requests=${requests} --max-time=${maxtime} --percentile=95 run

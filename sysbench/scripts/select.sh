#!/bin/bash

set -x

source ./conf.sh

sysbench --test=./lua-tests/db/select.lua --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --oltp-tables-count=${tcount} \
 --oltp-table-size=${tsize} --num-threads=${threads} --report-interval=60 \
 --max-requests=${requests} --percentile=95  --max-time=${maxtime} run

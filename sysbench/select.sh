#!/bin/bash

set -x

source ./conf.sh

sysbench --test=./lua-tests/db/select.lua --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
 --oltp-tables-count=${tcount} --oltp-table-size=${tsize} \
 --num-threads=${threads} --report-interval=${interval} \
 --max-requests=${requests} --percentile=95  --max-time=${maxtime} run

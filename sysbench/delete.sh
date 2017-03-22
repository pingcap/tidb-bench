#!/bin/bash

set -x

. ./conf.sh

sysbench --test=./lua-tests/db/delete.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
 --oltp-tables-count=${tcount} --oltp-table-size=${tsize} \
 --num-threads=${threads} --report-interval=${interval} \
 --max-requests=${requests} --max-time=${maxtime} --percentile=95 run

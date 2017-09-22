#!/bin/bash

set -x

. ./conf.sh

sysbench ./lua/oltp_delete.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
 --tables=${tcount} --table-size=${tsize} \
 --threads=${threads} --report-interval=${interval} \
 --events=${requests} --time=${maxtime} --percentile=95 run

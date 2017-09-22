#!/bin/bash

set -x

. ./conf.sh

sysbench ./lua/oltp_insert.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
 --tables=${tcount} --table-size=${tsize} \
 --threads=${threads} --report-interval=${interval} \
 --events=${requests} --percentile=95 --time=${maxtime} run

#!/bin/bash

set -x

. ./conf.sh

sysbench ./lua/select_random_points.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
 --tables=${tcount} --table_size=${tsize} \
 --threads=${threads} --report-interval=${interval} \
 --max-requests=${requests} --percentile=95  --time=${maxtime} run

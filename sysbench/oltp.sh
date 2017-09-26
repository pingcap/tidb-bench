#!/bin/bash

set -x

. ./conf.sh

# run
sysbench ./lua/oltp_read_write.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
  --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
  --tables=${tcount} --table_size=${tsize} \
  --threads=${threads} --events=${requests} \
  --report-interval=${interval} --rand-type=uniform \
  --time=${maxtime} --percentile=95 run

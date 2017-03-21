#!/bin/bash

set -x

. ./conf.sh


sysbench --test=./lua-tests/db/oltp.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
  --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
  --oltp-tables-count=${tcount} cleanup


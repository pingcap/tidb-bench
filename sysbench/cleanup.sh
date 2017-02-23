#!/bin/bash

set -x

source ./conf.sh


sysbench --test=./lua-tests/db/oltp.lua --mysql-host=${host} --mysql-port=${port} \
  --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
  --oltp-tables-count=${tcount} cleanup


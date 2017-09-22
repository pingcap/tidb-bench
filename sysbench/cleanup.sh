#!/bin/bash

set -x

. ./conf.sh


sysbench ./lua/oltp_read_write.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
  --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
  --tables=${tcount} cleanup


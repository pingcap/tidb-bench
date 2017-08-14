#!/bin/bash

set -x

. ./conf.sh

if [[ ${password} = "" ]];
then
    mysql -h ${host} -P ${port} -u${user} -e "CREATE DATABASE IF NOT EXISTS ${dbname}"
else
    mysql -h ${host} -P ${port} -u${user} -p{$password} -e "CREATE DATABASE IF NOT EXISTS ${dbname}"
fi

sysbench --test=./lua-tests/db/oltp.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --oltp-tables-count=${tcount} --mysql-db=${dbname} \
 --oltp-table-size=0 --rand-init=on prepare

sleep 5

sysbench --test=./lua-tests/db/parallel_prepare.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --oltp-tables-count=${tcount} --mysql-db=${dbname} \
 --oltp-table-size=${tsize} --num-threads=${threads}  --rand-init=on run


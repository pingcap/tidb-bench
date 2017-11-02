#!/bin/bash

set -x

. ./conf.sh

((pnum=${tcount}*5)) 

if [[ ${password} = "" ]];
then
    mysql -h ${host} -P ${port} -u${user} -e "CREATE DATABASE IF NOT EXISTS ${dbname}"
else
    mysql -h ${host} -P ${port} -u${user} -p{$password} -e "CREATE DATABASE IF NOT EXISTS ${dbname}"
fi

sysbench ./lua/oltp_read_write.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
 --tables=${tcount} --table_size=0 --threads=${threads} prepare

sleep 5

sysbench ./lua/parallel_prepare.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --oltp-tables-count=${tcount} --mysql-db=${dbname} \
 --oltp-table-size=${tsize} --num-threads=${pnum}  --rand-init=on run
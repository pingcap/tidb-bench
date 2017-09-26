#!/bin/bash

set -x

. ./conf.sh

if [[ ${password} = "" ]];
then
    mysql -h ${host} -P ${port} -u${user} -e "CREATE DATABASE IF NOT EXISTS ${dbname}"
else
    mysql -h ${host} -P ${port} -u${user} -p${password} -e "CREATE DATABASE IF NOT EXISTS ${dbname}"
fi

sysbench ./lua/oltp_read_write.lua --db-driver=${driver} --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --mysql-db=${dbname} \
 --tables=${tcount} --table_size=${tsize} --threads=${threads} prepare


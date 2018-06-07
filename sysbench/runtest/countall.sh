#!/bin/bash

date;

for i in $(mysql -h127.0.0.1 -uroot -P4000 -D $1 -Nse "show tables")
do
    mysql -h127.0.0.1 -uroot -P4000 -D $1 -e "select count(*) from $i"
    mysql -h127.0.0.1 -uroot -P4000 -D $1 -e "analyze table $i"
done

date;

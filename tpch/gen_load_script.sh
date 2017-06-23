#!/bin/bash
set -e
prefix=DBGEN/
write_to_file()
{
    rm -f loaddata.sql
    file="loaddata.sql"

    if [ ! -f "$file" ] ; then
        touch "$file"
    fi

    echo 'USE tpch;\n' >> $file
    DIR=`pwd`
    for tbl in `ls dbgen/*.tbl`; do
        table=$(echo "${tbl%.*}" | tr '[:lower:]' '[:upper:]')
        echo "LOAD DATA LOCAL INFILE '$DIR/$tbl' INTO TABLE ${table#$prefix}" >> $file
        echo "FIELDS TERMINATED BY '|';" >> $file
    done
}

write_to_file

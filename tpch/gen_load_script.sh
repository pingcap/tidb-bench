#!/bin/bash
set -e
prefix=DBGEN/
write_to_file()
{
    rm -f loaddata.sql
    file="loaddata.sql"

    for tbl in `ls dbgen/*.tbl`; do
        table=$(echo "${tbl%.*}" | tr '[:lower:]' '[:upper:]')
	      name=${table#$prefix}
	      file="$name.sql"
	      if [ ! -f "$file" ] ; then
            touch "$file"
            echo "LOAD DATA LOCAL INFILE '$DIR/$tbl' INTO TABLE ${table#$prefix}" >> $file
            echo "FIELDS TERMINATED BY '|';" >> $file
    	  fi
    done
}

write_to_file

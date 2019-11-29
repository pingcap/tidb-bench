#!/bin/bash

tables=('lineitem' 'orders' 'part' 'partsupp' 'supplier' 'customer' 'region' 'nation')

set -eux
set -o pipefail

source ./_env.sh

for table in ${tables[*]}
do
    mysql -h $tidb_host -P $tidb_port -uroot -D tpch${tpch_scale} -e "analyze table $table" & 
done
wait

#!/bin/bash

table="$1"
blocks="$2"

set -eux
set -o pipefail

source ../_env.sh

map_lineitem="L"
map_orders="O"
map_customer="c"
map_nation="n"
map_parts="P"
map_region="r"
map_partsupp="S"
map_supplier="s"

if [ -z "$table" ]; then
    echo "usage: <bin> table-name [blocks-number=1]" >&2
    exit 1
fi

if [ -z "$blocks" ]; then
    blocks="1"
fi

table_arg="map_$table"

if [ "$blocks" == "1" ]; then
        ./dbgen -s $tpch_scale -T ${!table_arg}
else
        for ((i=1; i<$blocks+1; ++i)); do
                ./dbgen -s $tpch_scale -T ${!table_arg} -C $blocks -S $i &
        done
	wait
fi

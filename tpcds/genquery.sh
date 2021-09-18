#!/bin/bash
set -eu

SCALE=$1
TEMPLATE_DIR="../query_templates"
OUTPUT_DIR="queries"
QUERY_ID=""

function generate_query()
{
    ./dsqgen \
    -DIRECTORY "$TEMPLATE_DIR" \
    -INPUT "$TEMPLATE_DIR/templates.lst" \
    -SCALE $SCALE \
    -OUTPUT_DIR $OUTPUT_DIR \
    -DIALECT netezza \
    -TEMPLATE "query$QUERY_ID.tpl"
    mv "$OUTPUT_DIR/query_0.sql" "$OUTPUT_DIR/query_$QUERY_ID.sql"
}

function split_sql()
{
    cd $OUTPUT_DIR

    count=`grep ';' query_$QUERY_ID.sql | wc -l`
    if [[ $count -eq 1 ]]; then
        cd -
        return
    fi

    csplit --quiet --prefix=query_$QUERY_ID -k --suppress-matched --suffix-format="_%d.sql" query_$QUERY_ID.sql "/;/+1"
    rm query_$QUERY_ID.sql
    cd -
}

unsupported="14 18 22 27 36 5 67 70 77 80 86" # rollup function
unsupported=$unsupported" 2 11 23 39 4 59" # tidb bug

cd tools
rm -rf $OUTPUT_DIR
mkdir $OUTPUT_DIR
for i in {1..99}; do
    supported=1;
    for j in $unsupported; do
        if [ $i -eq $j ]; then
            supported=0;
            break;
        fi
    done
    if [ $supported -eq 0 ]; then
        continue;
    fi
    QUERY_ID="$i"
    generate_query
    split_sql
done
mv $OUTPUT_DIR ..
cd ..

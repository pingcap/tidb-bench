source _env.sh
set -ue

cat $META_DIR/tables | awk -F ' ' '{print$3}' | while read table; do
    bash create.sh
    #bash gen.sh "$table"
    bash load.sh "$table"
    done

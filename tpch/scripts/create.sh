table="$1"

set -eu

source _env.sh
source _create.sh

if [ -z "$table" ]; then
	  ls $META_DIR/schema/ | awk -F '.' '{print $1}' | while read table; do
		    echo create_table $table
	  done
else
	  echo create_table $table
fi

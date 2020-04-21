#!/bin/bash
# sh gen_load_tiflash.sh 1 ./dss_tiflash.sql 

set -e
db_name="SF"$1
fddl=$2
if [ $# != 2 ] ; then
	echo "must input a postive integer for the scale factor and a ddl file"
	exit
else
	echo $db_name 
fi

## generate tpch data
echo "generating tpch data, which will cost long time!!!"
mkdir $db_name
cd dbgen
./dbgen -s $1
cd ../
mv ./dbgen/*tbl  ./$db_name
echo "tpch data is ready"
cd $db_name
pwd

cp ../$fddl ./ddl.sql
sed -i "s/TPCH/$db_name/" ddl.sql

## issue ddl to database
mysql -u root -h 127.0.0.1 -P 4000 < ddl.sql

write_to_file()
{
    for tbl in `ls *.tbl`; do
        table=$(echo "${tbl%.*}" | tr '[:lower:]' '[:upper:]')
	name=${table#$prefix}
	file="${db_name}.$name.csv"
	mv $tbl $file
    done
}
write_to_file
#rm ddl.sql
cd ..

echo "DDL DONE! please use lighting to fast import data whose location listed above."

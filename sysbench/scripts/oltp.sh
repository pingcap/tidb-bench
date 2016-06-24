if [ $# != 8 ]; then
	echo "Usage: $0 host port dbuser dbpasswd tables-count table-size num-threads max-time(seconds)"
	exit 1
fi

host=$1
port=$2
user=$3
password=$4
tcount=$5
tsize=$6
threads=$7
seconds=$8

# run
sysbench --test=./lua-tests/db/oltp.lua --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --oltp-tables-count={tcount} \
 --oltp-table-size=${tsize} --num-threads=${threads} \
 --oltp-read-only=off --report-interval=60 --rand-type=uniform \
 --max-time=${seconds} --percentile=99 run 2>&1 > oltp.log &

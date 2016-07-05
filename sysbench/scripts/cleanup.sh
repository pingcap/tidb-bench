
if [ $# != 5 ]; then
	echo "Usage: $0 host port dbuser dbpasswd tables-count"
	exit 1
fi

host=$1
port=$2
user=$3
password=$4
tcount=$5

sysbench --test=./lua-tests/db/oltp.lua --mysql-host=${host} --mysql-port=${port} \
 --mysql-user=${user} --mysql-password=${password} --oltp-tables-count=${tcount}  cleanup


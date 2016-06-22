
if [ $# != 10 ]; then
    echo "Usage: $0 host port dbuser dbpassword tables-count table-size num-threads max-requests max-time out-log"
    exit 1
fi

host=$1
port=$2
user=$3
password=$4
tcount=$5
tsize=$6
threads=$7
requests=$8
maxtime=$9
output=$10


####################### insert test #########################
echo "start insert test"
./prepare.sh $host $port $user $password $tcount $tsize
./insert.sh $host $port $user $password $tcount $tsize $threads $requests $output
./cleanup.sh $host $port $user $password $tcount
echo "finish start test"

####################### select test #########################
echo "start select test"
./prepare.sh $host $port $user $password $tcount $tsize
./select.sh $host $port $user $password $tcount $tsize $threads $maxtime $output
./cleanup.sh $host $port $user $password $tcount
echo "finish select test"

####################### delete test #########################
echo "start delete test"
./prepare.sh $host $port $user $password $tcount $tsize
./delete.sh $host $port $user $password $tcount $tsize $threads $requests $output
./cleanup.sh $host $port $user $password $tcount
echo "finish delete test"

####################### oltp test #########################
echo "start oltp test"
./prepare.sh $host $port $user $password $tcount $tsize
./oltp.sh $host $port $user $password $tcount $tsize $threads $maxtime $output
./cleanup.sh $host $port $user $password $tcount
echo "finish oltp test"


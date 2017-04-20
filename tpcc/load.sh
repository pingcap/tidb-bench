export LD_LIBRARY_PATH=/usr/local/mysql/lib/mysql/
DBNAME=tpcc100
WH=10
HOST=172.233.1.119
#HOST=127.0.0.1
PORT=4000
STEP=5

./tpcc_load -h $HOST -P $PORT -d $DBNAME -u root -p "" -w $WH -l 1 -m 1 -n $WH &

x=1

while [ $x -le $WH ]
do
 echo $x $(( $x + $STEP - 1 ))
./tpcc_load -h $HOST -P $PORT -d $DBNAME -u root -p "" -w $WH -l 2 -m $x -n $(( $x + $STEP - 1 )) &
./tpcc_load -h $HOST -P $PORT -d $DBNAME -u root -p "" -w $WH -l 3 -m $x -n $(( $x + $STEP - 1 )) &
./tpcc_load -h $HOST -P $PORT -d $DBNAME -u root -p "" -w $WH -l 4 -m $x -n $(( $x + $STEP - 1 )) &
 x=$(( $x + $STEP ))
done


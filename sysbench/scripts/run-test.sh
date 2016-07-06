
cleanup() {
	echo "run 116"
	cd /home/pingcap/work/deploy
	echo "$(pwd)"
	./run_116.sh
	sleep 3
}

createdb() {
	cd /home/pingcap/work/bench/tidb-bench/sysbench/scripts
	echo "$(pwd)"
	./createdb.sh
}

export LD_LIBRARY_PATH=/usr/local/lib

### insert bench ####
cleanup

createdb
./prepare.sh 127.0.0.1 5001 root "" 1 1000
./insert.sh 127.0.0.1 5001 root "" 1 1000 1 100000 2>&1 >> log
cleanup

createdb
./prepare.sh 127.0.0.1 5001 root "" 1 1000
./insert.sh 127.0.0.1 5001 root "" 1 1000 4 100000 2>&1 >> log
cleanup

createdb
./prepare.sh 127.0.0.1 5001 root "" 1 1000
./insert.sh 127.0.0.1 5001 root "" 1 1000 8 100000 2>&1 >> log
cleanup

createdb
./prepare.sh 127.0.0.1 5001 root "" 1 1000
./insert.sh 127.0.0.1 5001 root "" 1 1000 16 100000 2>&1 >> log
cleanup

### select bench ###
createdb
./prepare.sh 127.0.0.1 5001 root "" 1 100000
./select.sh 127.0.0.1 5001 root "" 1 100000 1 100000 2>&1 >> log
cleanup

createdb
./prepare.sh 127.0.0.1 5001 root "" 1 100000
./select.sh 127.0.0.1 5001 root "" 1 100000 4 100000 2>&1 >> log
cleanup

createdb
./prepare.sh 127.0.0.1 5001 root "" 1 100000
./select.sh 127.0.0.1 5001 root "" 1 100000 8 100000 2>&1 >> log
cleanup

createdb
./prepare.sh 127.0.0.1 5001 root "" 1 100000
./select.sh 127.0.0.1 5001 root "" 1 100000 16 100000 2>&1 >> log
cleanup

### oltp bench ###
createdb
./prepare.sh 127.0.0.1 5001 root "" 1 100000
./oltp.sh 127.0.0.1 5001 root "" 1 100000 1 100000 2>&1 >> log
cleanup

createdb
./prepare.sh 127.0.0.1 5001 root "" 1 100000
./oltp.sh 127.0.0.1 5001 root "" 1 100000 4 100000 2>&1 >> log
cleanup

createdb
./prepare.sh 127.0.0.1 5001 root "" 1 100000
./oltp.sh 127.0.0.1 5001 root "" 1 100000 8 100000 2>&1 >> log
cleanup

createdb
./prepare.sh 127.0.0.1 5001 root "" 1 100000
./oltp.sh 127.0.0.1 5001 root "" 1 100000 16 100000 2>&1 >> log
cleanup

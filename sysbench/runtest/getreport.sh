#!/bin/bash

RUNDIR=`pwd`

rm -f ./report/*.log

for i in 128 256 512 1024 2048
do
    sh $RUNDIR/cexec.sh "cat $RUNDIR/logs/${i}_select.sh.log" >> $RUNDIR/report/${i}_select.log
    sh $RUNDIR/cexec.sh "cat $RUNDIR/logs/${i}_oltp.sh.log" >> $RUNDIR/report/${i}_oltp.log
    sh $RUNDIR/cexec.sh "cat $RUNDIR/logs/${i}_insert.sh.log" >> $RUNDIR/report/${i}_insert.log
done

sleep 3
rm -f select.log oltp.log insert.log

for i in 128 256 512 1024 2048
do
   sh logparse.sh report/${i}_select.log >> ./select.log
   sh logparse.sh report/${i}_oltp.log >> ./oltp.log
   sh logparse.sh report/${i}_insert.log >> ./insert.log
done

cat ./select.log | awk -F ':' '{print $2}'
echo ""
cat ./oltp.log | awk -F ':' '{print $2}'
echo ""
cat ./insert.log | awk -F ':' '{print $2}'

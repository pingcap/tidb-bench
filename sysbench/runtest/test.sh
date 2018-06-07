
#!/bin/bash

RUNDIR=$(cd `dirname $0`; pwd)
cd $RUNDIR

basepath=$(dirname $(pwd))
cd $basepath

thread=$1
cmd=$2

sed "s/xxxxxx/${thread}/" $RUNDIR/conf.sh.toml > $basepath/conf.sh

nohup sh $basepath/$cmd 2>&1 > $RUNDIR/logs/${thread}_${cmd}.log &


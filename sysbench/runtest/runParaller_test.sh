#!/bin/bash

export NODE_LIST="t001 t002 t003"
RUNDIR=`pwd`

echo "The sysbench running dir is : $RUNDIR "
echo

function clsrun() {
  if [ -z "$NODE_LIST" ]; then
    echo
    echo Error: NODE_LIST environment variable must be set in .bash_profile
    exit 1
  fi

  if [[ $1 = '--background' ]]; then
    shift
    for i in $NODE_LIST; do
      ssh $sshauth -oStrictHostKeyChecking=no -n $i "$@" &
    done
    wait
  else
    for i in $NODE_LIST; do
      ssh $sshauth -oStrictHostKeyChecking=no $i "$@"
    done
  fi
}

#select
for thread in 128 256 512 1024 2048
do
    clsrun --background "$RUNDIR/test.sh $thread select.sh"
    sleep(300)
done

#oltp
for thread in 128 256 512 1024 2048
do
    clsrun --background "$RUNDIR/test.sh $thread oltp.sh"
    sleep(300)
done

#insert
for thread in 128 256 512 1024 2048
do
    clsrun --background "$RUNDIR/test.sh $thread insert.sh"
    sleep(300)
done

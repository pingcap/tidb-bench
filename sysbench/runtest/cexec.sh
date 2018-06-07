#!/bin/bash

cmd=$1

#for i in `seq 1 3`
for i in 1 2 3
do
	echo ---------------172.16.20.$i-------------------
	ssh t00$i $cmd
done

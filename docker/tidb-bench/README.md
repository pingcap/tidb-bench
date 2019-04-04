This image includes various utilities used to benchmark TiDB.

# Performance tests

* sysbench
* go-ycsb


# Disk tests

*Note:* All the commands need to be run under the disk mount point. And the test.data file need to be deleted before test.

## fio
* Read
```
fio -ioengine=libaio -bs=32k -direct=1 -thread -rw=read -size=10G -filename=test.data -name="PingCAP max throughput" -iodepth=4 -runtime=60
```

* Write
```
fio -ioengine=libaio -bs=32k -direct=1 -thread -rw=write -size=10G -filename=test.data -name="PingCAP max throughput" -iodepth=4 -runtime=60
```

* Random read
```
fio -ioengine=libaio -bs=32k -direct=1 -thread -rw=randread -size=10G -filename=test.data -name="PingCAP max throughput" -iodepth=4 -runtime=60
```

* Random write
```
fio -ioengine=libaio -bs=32k -direct=1 -thread -rw=randwrite  -size=10G -filename=test.data -name="PingCAP max throughput" -iodepth=4 -runtime=60
```

* Random read & write
```
fio -ioengine=libaio -bs=32k -direct=1 -thread -rw=randrw -percentage_random=100,0 -size=10G -filename=test.data -name="PingCAP max throughput" -iodepth=4 -runtime=60
```

## dd

* Cache write
```
dd bs=4k count=400000 if=/dev/zero of=test.data
```

* Direct write
```
dd bs=4k count=400000 if=/dev/zero of=test.data oflag=direct
```

* Direct read
```
dd bs=4k count=400000 if=test.data of=/dev/null& oflag=direct
```

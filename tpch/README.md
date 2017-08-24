# TPCH test for TiDB
By runing the following command you can generate and load tpch data into TiDB cluster if there is 
a TiDB cluster present.
```
bash genandloadalldata.sh
```

Before you actually execute above command, you may want to explore more. You can change
parameter in `_env.sh`.

`TPCH_BLOCKS` is how many block will be generated for a single table.
`TPCH_STEP` is how many subtables will be loaded concurrently via mysql client to TiDB cluster.
`TPCH_SCALE` is the scale factor for dbgen.

You may want to modify above parameters on your own interest. 

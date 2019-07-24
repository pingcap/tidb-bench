# tidb-bench

TiDB standard test suite.

## Support

- OLTP Benchmark
  - [sql-bench](./sql-bench)
  - [Sysbench](./sysbench)

- OLAP Benchmark
  - [TPC-DS](./tpcds)
  - [TPC-H](./tpch)
  - [Star Schema Benchmark](./ssb)
  - [Aggregate Benchmark](./abm)

## Tips

- For the Sysbench test, we only provide a simple script, which requires `sysbench` to be installed.
- For the TPC-C test codes, please refer to another separate [repo](https://github.com/pingcap/benchmarksql).
+ Please follow our guides to run the tests: 
    - [Sysbench](https://pingcap.com/docs/v3.0/benchmark/how-to-run-sysbench/)
    - [TPC-C](https://pingcap.com/docs/v3.0/benchmark/how-to-run-tpcc)

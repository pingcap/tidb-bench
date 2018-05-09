# ABM Tables

This is an introduction to tables inside the Aggregate Benchmark(ABM).

## Common Schemas

There are 32 tables inside this benchmark, all of them have the following same column definitions:

| Column Name | Column Type | Column Flags | NDV per Group          |
|-------------|-------------|--------------|------------------------|
| k           | bigint      | not null     | 1                      |
| v0          | bigint      | not null     | 2^0, 1                 |
| v1          | bigint      | not null     | 2^1, 2                 |
| v2          | bigint      | not null     | 2^2, 4                 |
| v3          | bigint      | not null     | 2^3, 8                 |
| v4          | bigint      | not null     | 2^4, 16                |
| v5          | bigint      | not null     | 2^5, 32                |
| v6          | bigint      | not null     | 2^6, 64                |
| v7          | bigint      | not null     | 2^7, 128               |
| vfull       | bigint      | not null     | num\_group\_row\_count |

All the queries inside this benchmark use column `k` in the `GROUP BY` clause, that is to say, rows with the same value on column `k` belong to the same group.

In each group:
- column `v0` has 2^0, which is 1, distinct values.
- column `v1` has 2^1, which is 2, distinct values.
- column `v2` has 2^2, which is 4, distinct values.
- column `v3` has 2^3, which is 8, distinct values.
- column `v4` has 2^4, which is 16, distinct values.
- column `v5` has 2^5, which is 32, distinct values.
- column `v6` has 2^6, which is 64, distinct values.
- column `v7` has 2^7, which is 128, distinct values.
- column `vfull` have all the values to be unique and distinct.

## Number Of Groups

There are 8 kinds of group count:
- 2^0, 1
- 2^2, 4
- 2^4, 16
- 2^6, 64
- 2^8, 256
- 2^10, 1024
- 2^12, 4096
- num\_table\_row\_count

## Different Index Definitions

Totally, there are 4 kinds of index definitions:
1. no index definitions
2. only have index on column `k`
3. only have index on column pair (`k`, `v0`), (`k`, `v1`), ..., (`k`, `vfull`)
4. have both index definitions mentioned on 2 and 3

## All the Tables

| table name | group count            | index kinds | table row count |
|------------|------------------------|-------------|-----------------|
| t0\_0      | 2^0, 1                 | 0           | sf\*2^20        |
| t2\_0      | 2^2, 4                 | 0           | sf\*2^20        |
| t4\_0      | 2^4, 16                | 0           | sf\*2^20        |
| t6\_0      | 2^6, 64                | 0           | sf\*2^20        |
| t8\_0      | 2^8, 256               | 0           | sf\*2^20        |
| t10\_0     | 2^10, 1024             | 0           | sf\*2^20        |
| t12\_0     | 2^12, 4096             | 0           | sf\*2^20        |
| full\_0    | num\_table\_row\_count | 0           | sf\*2^20        |
| t0\_1      | 2^0, 1                 | 1           | sf\*2^20        |
| t2\_1      | 2^2, 4                 | 1           | sf\*2^20        |
| t4\_1      | 2^4, 16                | 1           | sf\*2^20        |
| t6\_1      | 2^6, 64                | 1           | sf\*2^20        |
| t8\_1      | 2^8, 256               | 1           | sf\*2^20        |
| t10\_1     | 2^10, 1024             | 1           | sf\*2^20        |
| t12\_1     | 2^12, 4096             | 1           | sf\*2^20        |
| full\_1    | num\_table\_row\_count | 1           | sf\*2^20        |
| t0\_2      | 2^0, 1                 | 2           | sf\*2^20        |
| t2\_2      | 2^2, 4                 | 2           | sf\*2^20        |
| t4\_2      | 2^4, 16                | 2           | sf\*2^20        |
| t6\_2      | 2^6, 64                | 2           | sf\*2^20        |
| t8\_2      | 2^8, 256               | 2           | sf\*2^20        |
| t10\_2     | 2^10, 1024             | 2           | sf\*2^20        |
| t12\_2     | 2^12, 4096             | 2           | sf\*2^20        |
| full\_2    | num\_table\_row\_count | 2           | sf\*2^20        |
| t0\_3      | 2^0, 1                 | 3           | sf\*2^20        |
| t2\_3      | 2^2, 4                 | 3           | sf\*2^20        |
| t4\_3      | 2^4, 16                | 3           | sf\*2^20        |
| t6\_3      | 2^6, 64                | 3           | sf\*2^20        |
| t8\_3      | 2^8, 256               | 3           | sf\*2^20        |
| t10\_3     | 2^10, 1024             | 3           | sf\*2^20        |
| t12\_3     | 2^12, 4096             | 3           | sf\*2^20        |
| full\_3    | num\_table\_row\_count | 3           | sf\*2^20        |

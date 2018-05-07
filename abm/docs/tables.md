# ABM Tables

This is an introduction for tables inside the Aggregate Benchmark(ABM).

## Common Schemas

There are 32 tables inside this benchmark, all of them have the following same column definitions:

| Column Name | Column Type | Column Flags |
|-------------|-------------|--------------|
| k           | bigint      | not null     |
| v0          | bigint      | not null     |
| v1          | bigint      | not null     |
| v2          | bigint      | not null     |
| v3          | bigint      | not null     |
| v4          | bigint      | not null     |
| v5          | bigint      | not null     |
| v6          | bigint      | not null     |
| v7          | bigint      | not null     |
| vfull       | bigint      | not null     |

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
- 2^0
- 2^2
- 2^4
- 2^6
- 2^8
- 2^10
- 2^12
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
| t0_0       | 2^0                    | 0           | sf\*2^10        |
| t2_0       | 2^2                    | 0           | sf\*2^10        |
| t4_0       | 2^4                    | 0           | sf\*2^10        |
| t6_0       | 2^6                    | 0           | sf\*2^10        |
| t8_0       | 2^8                    | 0           | sf\*2^10        |
| t10_0      | 2^10                   | 0           | sf\*2^10        |
| t12_0      | 2^12                   | 0           | sf\*2^10        |
| full_0     | num\_table\_row\_count | 0           | sf\*2^10        |
| t0_1       | 2^0                    | 1           | sf\*2^10        |
| t2_1       | 2^2                    | 1           | sf\*2^10        |
| t4_1       | 2^4                    | 1           | sf\*2^10        |
| t6_1       | 2^6                    | 1           | sf\*2^10        |
| t8_1       | 2^8                    | 1           | sf\*2^10        |
| t10_1      | 2^10                   | 1           | sf\*2^10        |
| t12_1      | 2^12                   | 1           | sf\*2^10        |
| full_1     | num\_table\_row\_count | 1           | sf\*2^10        |
| t0_2       | 2^0                    | 2           | sf\*2^10        |
| t2_2       | 2^2                    | 2           | sf\*2^10        |
| t4_2       | 2^4                    | 2           | sf\*2^10        |
| t6_2       | 2^6                    | 2           | sf\*2^10        |
| t8_2       | 2^8                    | 2           | sf\*2^10        |
| t10_2      | 2^10                   | 2           | sf\*2^10        |
| t12_2      | 2^12                   | 2           | sf\*2^10        |
| full_2     | num\_table\_row\_count | 2           | sf\*2^10        |
| t0_3       | 2^0                    | 3           | sf\*2^10        |
| t2_3       | 2^2                    | 3           | sf\*2^10        |
| t4_3       | 2^4                    | 3           | sf\*2^10        |
| t6_3       | 2^6                    | 3           | sf\*2^10        |
| t8_3       | 2^8                    | 3           | sf\*2^10        |
| t10_3      | 2^10                   | 3           | sf\*2^10        |
| t12_3      | 2^12                   | 3           | sf\*2^10        |
| full_3     | num\_table\_row\_count | 3           | sf\*2^10        |

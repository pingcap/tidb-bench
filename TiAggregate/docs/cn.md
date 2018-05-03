# TiAggregate 简介

## 目的和作用

端到端的测试 TiDB 的聚合性能，包括但不限于：
- 执行计划是否够好
- 执行引擎是否够快

## 测试场景

原型 1：
```sql
SELECT   some_agg_func(val_col)
FROM     table_name
GROUP BY key_col;
```

原型 2：
```sql
SELECT   some_agg_func(DISTINCT val_col)
FROM     table_name
GROUP BY key_col;
```

综合上述两种测试场景，我们需要考虑的变量有：
- 整个表的 row count
- 整个表的 key count
- 同一个 group 内 val\_col 的 NDV（主要为带 DISTINCT 的聚合函数设计）
- 是否有 (key\_col) 索引
- 是否有 (key\_col, val\_col) 这样的联合索引

## 表结构设计

为不使问题复杂化，我们暂时只考虑 BIGINT 类型的值，并且每个表只有一个 key\_col，有很多 val\_col，每个 val\_col 中同一个 group 内的 NDV 不同，于是初步的表结构可以设计成这样：
```sql
CREATE TABLE table_0 (
    k   BIGINT NOT NULL COMMENT "NDV percentage in a table:   0%",
    v0  BIGINT NOT NULL COMMENT "NDV percentage in a group:   0%",
    v1  BIGINT NOT NULL COMMENT "NDV percentage in a group:  10%",
    v2  BIGINT NOT NULL COMMENT "NDV percentage in a group:  20%",
    v3  BIGINT NOT NULL COMMENT "NDV percentage in a group:  30%",
    v4  BIGINT NOT NULL COMMENT "NDV percentage in a group:  40%",
    v5  BIGINT NOT NULL COMMENT "NDV percentage in a group:  50%",
    v6  BIGINT NOT NULL COMMENT "NDV percentage in a group:  60%",
    v7  BIGINT NOT NULL COMMENT "NDV percentage in a group:  70%",
    v8  BIGINT NOT NULL COMMENT "NDV percentage in a group:  80%",
    v9  BIGINT NOT NULL COMMENT "NDV percentage in a group:  90%",
    v10 BIGINT NOT NULL COMMENT "NDV percentage in a group: 100%"
);

CREATE TABLE table_1 (
    k   BIGINT NOT NULL COMMENT "NDV percentage in a table:  10%",
    v0  BIGINT NOT NULL COMMENT "NDV percentage in a group:   0%",
    v1  BIGINT NOT NULL COMMENT "NDV percentage in a group:  10%",
    v2  BIGINT NOT NULL COMMENT "NDV percentage in a group:  20%",
    v3  BIGINT NOT NULL COMMENT "NDV percentage in a group:  30%",
    v4  BIGINT NOT NULL COMMENT "NDV percentage in a group:  40%",
    v5  BIGINT NOT NULL COMMENT "NDV percentage in a group:  50%",
    v6  BIGINT NOT NULL COMMENT "NDV percentage in a group:  60%",
    v7  BIGINT NOT NULL COMMENT "NDV percentage in a group:  70%",
    v8  BIGINT NOT NULL COMMENT "NDV percentage in a group:  80%",
    v9  BIGINT NOT NULL COMMENT "NDV percentage in a group:  90%",
    v10 BIGINT NOT NULL COMMENT "NDV percentage in a group: 100%"
);
```

这样我们总共有 44 个表:
- 11 个表没有任何索引
- 11 个表只有索引 index(k)
- 11 个表只有索引 index(k, v0), index(k, v1), ..., index(k, v10)
- 11 个表同时有索引 index(k) 和 index(k, v0), index(k, v1), ..., index(k, v10)

## Benchmark Query 设计
在每个表上我们都可以进行同样的查询，这些查询可以分为这么几类：

## 1. 没有 DISTINCT 属性
```sql
SELECT COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
```
每个表 1 个这样的查询就够了

### 2. 有 1 个 DISTINCT 属性
```sql
SELECT AVG(DISTINCT v0 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v1 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v2 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v3 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v4 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v5 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v6 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v7 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v8 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v9 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v10) FROM table_0 GROUP BY k;

SELECT AVG(DISTINCT v0 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v1 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v2 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v3 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v4 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v5 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v6 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v7 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v8 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v9 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v10) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0) FROM table_0 GROUP BY k;
```
每个表有 22 个这样的查询

### 3. 有 2 个 DISTINCT 属性
```sql
SELECT AVG(DISTINCT v0 ) COUNT(DISTINCT v0 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v1 ) COUNT(DISTINCT v1 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v2 ) COUNT(DISTINCT v2 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v3 ) COUNT(DISTINCT v3 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v4 ) COUNT(DISTINCT v4 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v5 ) COUNT(DISTINCT v5 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v6 ) COUNT(DISTINCT v6 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v7 ) COUNT(DISTINCT v7 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v8 ) COUNT(DISTINCT v8 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v9 ) COUNT(DISTINCT v9 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v10) COUNT(DISTINCT v10) FROM table_0 GROUP BY k;

SELECT AVG(DISTINCT v0 ) COUNT(DISTINCT v1 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v1 ) COUNT(DISTINCT v2 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v2 ) COUNT(DISTINCT v3 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v3 ) COUNT(DISTINCT v4 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v4 ) COUNT(DISTINCT v5 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v5 ) COUNT(DISTINCT v6 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v6 ) COUNT(DISTINCT v7 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v7 ) COUNT(DISTINCT v8 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v8 ) COUNT(DISTINCT v9 ) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v9 ) COUNT(DISTINCT v10) FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v10) COUNT(DISTINCT v0 ) FROM table_0 GROUP BY k;

SELECT AVG(DISTINCT v0 ) COUNT(DISTINCT v0 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v1 ) COUNT(DISTINCT v1 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v2 ) COUNT(DISTINCT v2 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v3 ) COUNT(DISTINCT v3 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v4 ) COUNT(DISTINCT v4 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v5 ) COUNT(DISTINCT v5 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v6 ) COUNT(DISTINCT v6 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v7 ) COUNT(DISTINCT v7 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v8 ) COUNT(DISTINCT v8 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v9 ) COUNT(DISTINCT v9 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v10) COUNT(DISTINCT v10) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;

SELECT AVG(DISTINCT v0 ) COUNT(DISTINCT v1 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v1 ) COUNT(DISTINCT v2 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v2 ) COUNT(DISTINCT v3 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v3 ) COUNT(DISTINCT v4 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v4 ) COUNT(DISTINCT v5 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v5 ) COUNT(DISTINCT v6 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v6 ) COUNT(DISTINCT v7 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v7 ) COUNT(DISTINCT v8 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v8 ) COUNT(DISTINCT v9 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v9 ) COUNT(DISTINCT v10) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
SELECT AVG(DISTINCT v10) COUNT(DISTINCT v0 ) COUNT(v0), SUM(v0), AVG(v0), MIN(v0), MAX(v0)  FROM table_0 GROUP BY k;
```
每个表有 44 个这样的查询

## 关于表的 row count

每个表的 row count 相同，初步可以设计为：SF * 100,0000

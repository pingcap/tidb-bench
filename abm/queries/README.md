# ABM Queries

## Usage

- Generate Queries: `./gen_query.py`
- Remove Queries: `./del_query.py`

## Brief Introduction

Based on the query prototype, we have the following query classes:
- no-distinct
- one-distinct-without-others
- one-distinct-with-others
- two-different-distinct-without-others
- two-different-distinct-with-others
- two-same-distinct-without-others
- two-same-distinct-with-others

### 1. no-distinct

They are generated based on the following query prototype:
```py
for tableName in tableNames:
    sql = "select count(v0), sum(v0), avg(v0), min(v0), max(v0) from {} group by k;\n".format(tableName)
```

32 queries in total.

### 2. one-distinct-without-others

They are generated based on the following query prototype:
```py
for tableName in tableNames:
    for colName in colNames:
        sql = "select avg(distinct {}) from {} group by k;\n".format(colName, tableName)
```

32 * 9 queries in total.

### 3. one-distinct-with-others

They are generated based on the following query prototype:
```py
for tableName in tableNames:
    for colName in colNames:
        sql = "select avg(distinct {}) count(v0), sum(v0), avg(v0), min(v0), max(v0) from {} group by k;\n".format(colName, tableName)
```

32 * 9 queries in total.

### 4. two-different-distinct-without-others

They are generated based on the following query prototype:
```py
for tableName in tableNames:
    for i, colName in enumerate(colNames):
        if i == len(colNames) - 1:
            nextColName = colNames[0]
        else:
            nextColName = colNames[i+1]
        sql = "select avg(distinct {}) count(distinct {}) from {} group by k;\n".format(colName, nextColName, tableName)
```

32 * 9 queries in total.

### 5. two-different-distinct-with-others

They are generated based on the following query prototype:
```py
for tableName in tableNames:
    for i, colName in enumerate(colNames):
        if i == len(colNames) - 1:
            nextColName = colNames[0]
        else:
            nextColName = colNames[i+1]
        sql = "select avg(distinct {}) count(distinct {}) count(v0), sum(v0), avg(v0), min(v0), max(v0) from {} group by k;\n".format(colName, nextColName, tableName)
```

32 * 9 queries in total.

### 6. two-same-distinct-without-others

They are generated based on the following query prototype:
```py
for tableName in tableNames:
    for colName in colNames:
        sql = "select avg(distinct {}) count(distinct {}) from {} group by k;\n".format(colName, colName, tableName)
```

32 * 9 queries in total.

### 7. two-same-distinct-with-others

They are generated based on the following query prototype:
```py
for tableName in tableNames:
    for colName in colNames:
        sql = "select avg(distinct {}) count(distinct {}) count(v0), sum(v0), avg(v0), min(v0), max(v0) from {} group by k;\n".format(colName, colName, tableName)
```

32 * 9 queries in total.


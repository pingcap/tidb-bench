#!/usr/bin/env python
#!coding:utf-8

def print_query(queryId, sql):
    with open("{}.sql".format(queryId), 'w+') as f:
        f.write(sql)

def gen_no_distinct_queries(tableNames, queryId):
    for tableName in tableNames:
        sql = "select count(v0), sum(v0), avg(v0), min(v0), max(v0) from {} group by k;\n".format(tableName)
        print_query(queryId, sql)
        queryId = queryId + 1
    return queryId

def gen_one_distinct_queries(tableNames, colNames, queryId):
    for tableName in tableNames:
        for colName in colNames:
            sql = "select avg(distinct {}) from {} group by k;\n".format(colName, tableName)
            print_query(queryId, sql)
            queryId = queryId + 1

    for tableName in tableNames:
        for colName in colNames:
            sql = "select avg(distinct {}) count(v0), sum(v0), avg(v0), min(v0), max(v0) from {} group by k;\n".format(colName, tableName)
            print_query(queryId, sql)
            queryId = queryId + 1

    return queryId

def gen_two_distinct_queries(tableNames, colNames, queryId):
    for tableName in tableNames:
        for colName in colNames:
            sql = "select avg(distinct {}) count(distinct {}) from {} group by k;\n".format(colName, colName, tableName)
            print_query(queryId, sql)
            queryId = queryId + 1

    for tableName in tableNames:
        for i, colName in enumerate(colNames):
            if i == len(colNames) - 1:
                nextColName = colNames[0]
            else:
                nextColName = colNames[i+1]
            sql = "select avg(distinct {}) count(distinct {}) from {} group by k;\n".format(colName, nextColName, tableName)
            print_query(queryId, sql)
            queryId = queryId + 1

    for tableName in tableNames:
        for colName in colNames:
            sql = "select avg(distinct {}) count(distinct {}) count(v0), sum(v0), avg(v0), min(v0), max(v0) from {} group by k;\n".format(colName, colName, tableName)
            print_query(queryId, sql)
            queryId = queryId + 1

    for tableName in tableNames:
        for i, colName in enumerate(colNames):
            if i == len(colNames) - 1:
                nextColName = colNames[0]
            else:
                nextColName = colNames[i+1]
            sql = "select avg(distinct {}) count(distinct {}) count(v0), sum(v0), avg(v0), min(v0), max(v0) from {} group by k;\n".format(colName, nextColName, tableName)
            print_query(queryId, sql)
            queryId = queryId + 1

    return queryId

def main():
    tableNames = [
        "t0_0",
        "t2_0",
        "t4_0",
        "t6_0",
        "t8_0",
        "t10_0",
        "t12_0",
        "full_0",
        "t0_1",
        "t2_1",
        "t4_1",
        "t6_1",
        "t8_1",
        "t10_1",
        "t12_1",
        "full_1",
        "t0_2",
        "t2_2",
        "t4_2",
        "t6_2",
        "t8_2",
        "t10_2",
        "t12_2",
        "full_2",
        "t0_3",
        "t2_3",
        "t4_3",
        "t6_3",
        "t8_3",
        "t10_3",
        "t12_3",
        "full_3",
    ]
    colNames = ["v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "vfull"]

    queryId = 0
    queryId = gen_no_distinct_queries(tableNames, queryId)
    queryId = gen_one_distinct_queries(tableNames, colNames, queryId)
    queryId = gen_two_distinct_queries(tableNames, colNames, queryId)

if __name__ == "__main__":
    main()

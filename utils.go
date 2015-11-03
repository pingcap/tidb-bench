package main

import (
	"database/sql"
	"fmt"
	"strings"
	"time"

	"github.com/ngaut/log"
	"github.com/rcrowley/go-metrics"
)

var (
	tm     = metrics.NewTimer()
	lastTm = tm.Snapshot()
)

func exec(sqlStmt string) error {
	db := connPool.Get().(*sql.DB)
	defer connPool.Put(db)
	log.Debug("exec sql:", sqlStmt)
	_, err := db.Exec(sqlStmt)
	return err
}

func mustExec(sqlStmt string) {
	tm.Time(func() {
		if err := exec(sqlStmt); err != nil {
			log.Error(sqlStmt)
			log.Fatal(err)
		}
	})
	if tm.Sum() > lastTm.Sum()+int64(*concurrent)*1e9 {
		log.Infof("%f %d %f", tm.Mean()*1e-9/float64(*concurrent), tm.Count(), float64(tm.Sum())*1e-9/float64(*concurrent))
		lastTm = tm.Snapshot()
	}
}

func dbMustExec(db *sql.DB, sqlStmt string) {
	log.Debug("exec sql:", sqlStmt)
	if _, err := db.Exec(sqlStmt); err != nil {
		log.Error(sqlStmt)
		log.Fatal(err)
	}
}

func query(sqlStmt string) (*sql.Rows, error) {
	db := connPool.Get().(*sql.DB)
	defer connPool.Put(db)
	log.Debug("query sql:", sqlStmt)
	rows, err := db.Query(sqlStmt)
	return rows, err
}

func checkQuery(sqlStmt string, expectRows int) {
	rows, err := query(sqlStmt)
	if err != nil {
		log.Error(sqlStmt)
	}
	actGot := 0
	for rows.Next() {
		actGot++
		if actGot > expectRows {
			log.Fatal(fmt.Sprintf("sql return count does not match. actual got %d great than expect %d\n", actGot, expectRows))
			break
		}
	}
	if actGot < expectRows {
		log.Fatal(fmt.Sprintf("sql return count does not match. actual got %d less than expect %d\n", actGot, expectRows))
	}
}

func dropTable() {
	log.Debug("drop bench table...")
	dropSql := fmt.Sprintf("DROP TABLE IF EXISTS %s", tableName)
	mustExec(dropSql)
	log.Debug("drop table successfully")
}

func createTable(force bool) {
	log.Debug("creating table...")
	var fieldNames []string
	for i := 0; i < *nCols; i++ {
		fieldNames = append(fieldNames, fmt.Sprintf("f_%d TEXT", i))
	}
	fields := strings.Join(fieldNames, ",")
	if force {
		dropTable()
	}
	sql := fmt.Sprintf("CREATE TABLE IF NOT EXISTS %s(id INT, %s, PRIMARY KEY(id))", tableName, fields)
	mustExec(sql)
	log.Debug("create table successfully")
}

func timing(desc string, fn func()) {
	fmt.Printf("%s ... [START]\n", desc)
	c := time.Now()
	fn()
	fmt.Printf("%s ... elapse : %fs [DONE]\n", desc, time.Since(c).Seconds())
}

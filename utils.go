package main

import (
	"database/sql"
	"fmt"
	"strings"
	"time"

	"github.com/ngaut/log"
)

func execTxn(sqlStmts []string) error {
	db := connPool.Get().(*sql.DB)
	defer connPool.Put(db)

	txn, err := db.Begin()
	if err != nil {
		return err
	}
	for _, sqlStmt := range sqlStmts {
		_, err := txn.Exec(sqlStmt)
		if err != nil {
			txn.Rollback()
			return err
		}
	}
	err = txn.Commit()
	if err != nil {
		txn.Rollback()
		return err
	}
	return nil
}

func exec(sqlStmt string) error {
	db := connPool.Get().(*sql.DB)
	defer connPool.Put(db)
	log.Debug("exec sql:", sqlStmt)
	_, err := db.Exec(sqlStmt)
	return err
}

func mustExec(sqlStmt string) {
	if err := exec(sqlStmt); err != nil {
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

func dropTable() {
	log.Debug("drop bench table")
	dropSql := fmt.Sprintf("DROP TABLE IF EXISTS %s", tableName)
	mustExec(dropSql)
}

func createTable(force bool) {
	fmt.Println("creating table...")
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
	fmt.Println("create table successfully")
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

func timing(desc string, fn func()) {
	fmt.Printf("%s ... [START]\n", desc)
	c := time.Now()
	fn()
	fmt.Printf("%s ... elapse : %fs [DONE]\n", desc, time.Since(c).Seconds())
}

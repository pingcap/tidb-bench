// Copyright 2015 PingCAP, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"bytes"
	"database/sql"
	"flag"
	"fmt"
	"strings"
	"sync"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/ngaut/log"
	"github.com/ngaut/pool"
)

var (
	rows       = flag.Int("rows", 10000, "row number of bench table, default: 10000")
	N          = flag.Int("N", 10000, "select/update times, default: 10000")
	concurrent = flag.Int("c", 50, "concurrent workers, default: 50")
	bulkSize   = flag.Int("bulk", 20, "test data size (one field, in byte), default: 20")
	nCols      = flag.Int("cols", 2, "bench table column number, default: 2")
	tblPrefix  = flag.String("prefix", "tidb", "bench table prefix, default: tidb")
	addr       = flag.String("addr", ":4000", "tidb-server addr, default: :4000")
	cases      = flag.String("t", "select", "test cases to run (select, update, delete), default: select,update")
	dbName     = flag.String("db", "test", "db name, default: test")
	force      = flag.Bool("f", true, "drop table first")
	user       = flag.String("u", "root", "username, default: root")
	password   = flag.String("p", "", "password, default: empty")
	logLevel   = flag.String("L", "error", "log level, default: error")
)

const (
	ConnPoolSize = 100
)

var (
	connPool = pool.NewCache("pool", ConnPoolSize, func() interface{} {
		db, err := sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s)/%s", *user, *password, *addr, *dbName))
		if err != nil {
			log.Fatal(err)
		}
		return db
	})
)

func exec(sqlStmt string) error {
	db := connPool.Get().(*sql.DB)
	defer connPool.Put(db)
	log.Debug("exec sql:", sqlStmt)
	_, err := db.Exec(sqlStmt)
	return err
}

func mustExec(sqlStmt string) {
	if err := exec(sqlStmt); err != nil {
		log.Fatal(err)
	}
}

func timing(desc string, fn func()) {
	fmt.Printf("%s ... [START]\n", desc)
	c := time.Now()
	fn()
	fmt.Printf("%s ... elapse : %v [DONE]\n", desc, time.Since(c))
}

func insertTestData(rows int, workers int) error {
	idChan := make(chan int)
	wg := sync.WaitGroup{}
	for i := 0; i < workers; i++ {
		// Worker func
		go func(workerId int) {
			wg.Add(1)
			defer wg.Done()
			for {
				id, ok := <-idChan
				// All data are sent
				if !ok {
					return
				}
				var bulks []string
				for i := 0; i < *nCols; i++ {
					// Fill dummy data, and generate SQL
					buf := bytes.Repeat([]byte{'A'}, *bulkSize)
					bulks = append(bulks, fmt.Sprintf("\"%s\"", string(buf)))
				}
				sql := fmt.Sprintf("INSERT INTO %s_bench VALUES(%d, %s);", *tblPrefix, id, strings.Join(bulks, ","))
				mustExec(sql)
			}
		}(i)
	}
	for i := 0; i < rows; i++ {
		idChan <- i
	}
	close(idChan)
	// Wait all worker to quit.
	wg.Wait()
	return nil
}

func dropTable() {
	log.Debug("drop bench table")
	dropSql := fmt.Sprintf("DROP TABLE IF EXISTS %s_bench", *tblPrefix)
	mustExec(dropSql)
}

func createTable() {
	var fieldNames []string
	for i := 0; i < *nCols; i++ {
		fieldNames = append(fieldNames, fmt.Sprintf("f_%d TEXT", i))
	}
	fields := strings.Join(fieldNames, ",")
	tblName := fmt.Sprintf("%s_bench", *tblPrefix)
	if *force {
		dropTable()
	}
	sql := fmt.Sprintf("CREATE TABLE IF NOT EXISTS %s(id INT, %s, PRIMARY KEY(id))", tblName, fields)
	mustExec(sql)
}

func main() {
	flag.Parse()
	log.SetLevelByString(*logLevel)
	timing("create table", func() {
		createTable()
	})
	timing("insert test data", func() {
		insertTestData(*rows, *concurrent)
	})
}

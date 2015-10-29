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
	"math/rand"
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
	tblPrefix  = flag.String("prefix", "", "bench table prefix, default: tidb_{random}")
	addr       = flag.String("addr", ":4000", "tidb-server addr, default: :4000")
	cases      = flag.String("t", "select", "test cases to run (select, update, delete), default: select,update")
	dbName     = flag.String("db", "test", "db name, default: test")
	force      = flag.Bool("f", true, "drop table first")
	user       = flag.String("u", "root", "username, default: root")
	password   = flag.String("p", "", "password, default: empty")
	logLevel   = flag.String("L", "error", "log level, default: error")

	tableName string
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

func init() {
	flag.Parse()
	if len(*tblPrefix) == 0 {
		// if user doesn't provide specific table prefix, we generate one.
		tableName = fmt.Sprintf("tidb_%v_bench", time.Now().UnixNano())
	} else {
		tableName = *tblPrefix + "_bench"
	}
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

func timing(desc string, fn func()) {
	fmt.Printf("%s ... [START]\n", desc)
	c := time.Now()
	fn()
	fmt.Printf("%s ... elapse : %fs [DONE]\n", desc, time.Since(c).Seconds())
}

func insertTestData(rows int, workers int) error {
	truncTable()
	idChan := make(chan int)
	wg := sync.WaitGroup{}
	for i := 0; i < workers; i++ {
		wg.Add(1)
		// Worker func
		go func(workerId int) {
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
				sql := fmt.Sprintf("INSERT INTO %s VALUES(%d, %s);", tableName, id, strings.Join(bulks, ","))
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

func insertWithPrepareTestData(rows int, workers int) error {
	truncTable()
	idChan := make(chan int)
	wg := sync.WaitGroup{}

	for i := 0; i < workers; i++ {
		wg.Add(1)
		// Worker func
		go func(workerId int) {
			defer wg.Done()
			var placeHolder []string
			for i := 0; i < *nCols; i++ {
				placeHolder = append(placeHolder, "?")
			}
			placeHolderStr := string(strings.Join(placeHolder, ", "))
			insStmt := fmt.Sprintf("PREPARE insStmt FROM 'INSERT INTO %s VALUES(?, %s)';",
				tableName, placeHolderStr)
			mustExec(insStmt)
			for {
				id, ok := <-idChan
				// All data are sent
				if !ok {
					return
				}
				var setFields []string
				var usingFields []string
				for i := 0; i < *nCols; i++ {
					// Fill dummy data, and generate SQL
					buf := bytes.Repeat([]byte{'A'}, *bulkSize)
					setFields = append(setFields, fmt.Sprintf("SET @txt_%d=\"%s\"", i, string(buf)))
					usingFields = append(usingFields, fmt.Sprintf("@txt_%d", i))
				}
				exeStmt := fmt.Sprintf("SET @id=%d; %s; EXECUTE insStmt USING @id, %s;",
					id, strings.Join(setFields, "; "), strings.Join(usingFields, ", "))
				mustExec(exeStmt)
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

func selectPointTestData(rows int, N int, workers int) error {
	idChan := make(chan int)
	wg := sync.WaitGroup{}
	for i := 0; i < workers; i++ {
		wg.Add(1)
		// Worker func
		go func(workerId int) {
			defer wg.Done()
			for {
				id, ok := <-idChan
				// All data are sent
				if !ok {
					return
				}
				sql := fmt.Sprintf("SELECT * FROM %s WHERE id=%d;", tableName, id)
				mustExec(sql)
			}
		}(i)
	}
	rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 0; i < N; i++ {
		idChan <- rnd.Intn(rows)
	}
	close(idChan)
	// Wait all worker to quit.
	wg.Wait()
	return nil
}

func selectRangeTestData(rows int, N int, workers int) error {
	type Range struct {
		x int
		y int
	}
	idChan := make(chan Range)
	wg := sync.WaitGroup{}
	for i := 0; i < workers; i++ {
		wg.Add(1)
		// Worker func
		go func(workerId int) {
			defer wg.Done()
			for {
				id, ok := <-idChan
				// All data are sent
				if !ok {
					return
				}
				sql := fmt.Sprintf("SELECT * FROM %s WHERE %d<=id and id<%d;",
					tableName, id.x, id.y)
				mustExec(sql)
			}
		}(i)
	}
	rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 0; i < N; i++ {
		low := rnd.Intn(rows)
		upp := low + rnd.Intn(rows)
		idChan <- Range{low, upp}
	}
	close(idChan)
	// Wait all worker to quit.
	wg.Wait()
	return nil
}

func dropTable() {
	log.Debug("drop bench table")
	dropSql := fmt.Sprintf("DROP TABLE IF EXISTS %s", tableName)
	mustExec(dropSql)
}

func createTable() {
	var fieldNames []string
	for i := 0; i < *nCols; i++ {
		fieldNames = append(fieldNames, fmt.Sprintf("f_%d TEXT", i))
	}
	fields := strings.Join(fieldNames, ",")
	if *force {
		dropTable()
	}
	sql := fmt.Sprintf("CREATE TABLE IF NOT EXISTS %s(id INT, %s, PRIMARY KEY(id))", tableName, fields)
	mustExec(sql)
}

func truncTable() {
	sql := fmt.Sprintf("TRUNCATE TABLE %s", tableName)
	mustExec(sql)
}

func main() {
	log.SetLevelByString(*logLevel)
	timing("create table", func() {
		createTable()
	})
	timing("insert test data", func() {
		insertTestData(*rows, *concurrent)
	})
	timing("insert with prepare test data", func() {
		insertWithPrepareTestData(*rows, *concurrent)
	})

	{
		insertTestData(*rows, *concurrent)
		timing("select point data", func() {
			selectPointTestData(*rows, *N, *concurrent)
		})
		timing("select range data", func() {
			selectRangeTestData(*rows, *N, *concurrent)
		})
	}
}

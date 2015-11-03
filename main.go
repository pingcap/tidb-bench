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
	insertOnly = flag.Bool("insert-only", true, "insert data only")

	tableName string
)

const (
	ConnPoolSize = 100
	ForceDrop    = true
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

func doBatchInsert(fromId, toId int, wg *sync.WaitGroup) {
	defer wg.Done()
	sqlFmt := "INSERT INTO %s VALUES %s"

	var vals []string
	for i := fromId; i < toId; i++ {
		var strFields []string
		for j := 0; j < *nCols; j++ {
			buf := bytes.Repeat([]byte{'A'}, *bulkSize)
			// ["aaaa", "aaaa"]
			strFields = append(strFields, "\""+string(buf)+"\"")
		}
		val := fmt.Sprintf("(%d, %s)", i, strings.Join(strFields, ","))
		vals = append(vals, val)
	}
	sql := fmt.Sprintf(sqlFmt, tableName, strings.Join(vals, ","))
	log.Info(sql)
	mustExec(sql)
}

func doSelectPointTestData(workerId int, wg *sync.WaitGroup, idChan chan int) {
	defer wg.Done()
	for {
		id, ok := <-idChan
		// All data are sent
		if !ok {
			return
		}
		sql := fmt.Sprintf("SELECT * FROM %s WHERE id=%d;", tableName, id)
		checkQuery(sql, 1)
	}
}

// for select/update/delete range
type queryRange struct {
	lower int
	upper int
}

func doSelectRangeTestData(workerId int, wg *sync.WaitGroup, rngChan chan queryRange) {
	defer wg.Done()
	for {
		rng, ok := <-rngChan
		// All data are sent
		if !ok {
			return
		}
		sql := fmt.Sprintf("SELECT * FROM %s WHERE %d<=id and id<%d;",
			tableName, rng.lower, rng.upper)

		// calc expect rows for testing
		var expectRows int
		var actUpp, actLow int
		if rng.upper > *rows {
			actUpp = *rows
		} else {
			actUpp = rng.upper
		}
		if rng.lower < 0 {
			actLow = 0
		} else {
			actLow = rng.lower
		}
		if actUpp < actLow {
			expectRows = 0
		} else {
			expectRows = actUpp - actLow
		}

		checkQuery(sql, expectRows)
	}
}

func insertTestData(rows int, workers int) error {
	wg := sync.WaitGroup{}
	batchSize := 100
	offset := 0
	for offset < rows {
		wg.Add(1)
		go doBatchInsert(offset, offset+batchSize, &wg)
		offset += batchSize
	}
	wg.Wait()
	return nil
}

func selectPointTestData(rows int, N int, workers int) error {
	idChan := make(chan int)
	wg := sync.WaitGroup{}
	for i := 0; i < workers; i++ {
		wg.Add(1)
		// Worker func
		go doSelectPointTestData(i, &wg, idChan)
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
	rngChan := make(chan queryRange)
	wg := sync.WaitGroup{}
	for i := 0; i < workers; i++ {
		wg.Add(1)
		// Worker func
		go doSelectRangeTestData(i, &wg, rngChan)
	}
	rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 0; i < N; i++ {
		low := rnd.Intn(rows)
		upp := low + rnd.Intn(rows)
		rngChan <- queryRange{low, upp}
	}
	close(rngChan)
	// Wait all worker to quit.
	wg.Wait()
	return nil
}

func main() {
	log.SetLevelByString(*logLevel)
	createTable(ForceDrop)
	{
		timing("insert test data", func() {
			insertTestData(*rows, *concurrent)
		})
		if !*insertOnly {
			timing("select point data", func() {
				selectPointTestData(*rows, *N, *concurrent)
			})
			timing("select range data", func() {
				selectRangeTestData(*rows, *N, *concurrent)
			})
		}
	}
}

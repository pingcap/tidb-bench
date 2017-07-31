// Copyright 2017 PingCAP, Inc.
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
	"bufio"
	"context"
	"database/sql"
	"flag"
	"fmt"
	"os"
	"strings"
	"sync"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/ngaut/log"
)

var (
	concurrent     = flag.Int("c", 50, "concurrent workers, default: 50")
	sqlCount       = flag.Int("sql-count", 0, "sql count, default read all data from file: 0")
	maxTime        = flag.Int("max-time", 0, "exec max time, default: 0")
	reportInterval = flag.Int("report-interval", 0, "report status interval, default: 0")
	addr           = flag.String("addr", ":4000", "tidb-server addr, default: :4000")
	dbName         = flag.String("db", "test", "db name, default: test")
	user           = flag.String("u", "root", "username, default: root")
	password       = flag.String("p", "", "password, default: empty")
	logLevel       = flag.String("L", "error", "log level, default: error")
	sqlFile        = flag.String("data", "./bench.sql", "SQL data file for bench")
)

var (
	statChan chan *stat
	db       *sql.DB
)

const (
	statChanSize  int = 10000
	queryChanSize int = 10000
)

func init() {
	flag.Parse()
	log.SetLevelByString(*logLevel)
	statChan = make(chan *stat, statChanSize)
	var err error
	db, err = sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s)/%s", *user, *password, *addr, *dbName))
	if err != nil {
		log.Fatal(err)
	}
}

func readQuery(ctx context.Context, queryChan chan string) {
	var querys []string
	file, err := os.Open(*sqlFile)
	if err != nil {
		log.Fatal(err)
	}
	defer func() {
		file.Close()
		close(queryChan)
	}()
	cnt := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		query := scanner.Text()
		cnt++
		queryChan <- query
		querys = append(querys, query)
		if *sqlCount != 0 && cnt >= *sqlCount {
			break
		}
		select {
		case <-ctx.Done():
			log.Infof("Get %d queries\n", cnt)
			return
		default:
		}
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
LOOP:
	for cnt < *sqlCount {
		for _, query := range querys {
			cnt++
			queryChan <- query
			if cnt >= *sqlCount {
				break LOOP
			}
			select {
			case <-ctx.Done():
				log.Infof("Get %d queries\n", cnt)
				return
			default:
			}
		}
	}
	log.Infof("Get %d queries\n", cnt)
}

func worker(ctx context.Context, id int, queryChan chan string, wg *sync.WaitGroup) {
	defer wg.Done()
	for {
		query, ok := <-queryChan
		if !ok {
			// No more query
			return
		}
		exec(query)
		select {
		case <-ctx.Done():
			return
		default:
		}
	}
}

// Structure for stat result.
type stat struct {
	spend time.Duration
	succ  bool
}

func exec(sqlStmt string) error {
	sql := strings.ToLower(sqlStmt)
	isQuery := strings.HasPrefix(sql, "select")
	// Get time
	startTs := time.Now()
	err := runQuery(sqlStmt, isQuery)
	if err != nil {
		log.Warnf("Exec sql [%s]: %s", sqlStmt, err)
		statChan <- &stat{}
		return err
	}
	statChan <- &stat{spend: time.Now().Sub(startTs), succ: true}
	return nil
}

func runQuery(sqlStmt string, isQuery bool) error {
	if isQuery {
		rows, err := db.Query(sqlStmt)
		defer rows.Close()
		if err != nil {
			return err
		}
		return nil
	}
	_, err := db.Exec(sqlStmt)
	return err
}

func statWorker(wg *sync.WaitGroup, startTs time.Time) {
	defer wg.Done()
	var (
		total       int64
		succ        int64
		spend       time.Duration
		tempStartTs = startTs
		tempTotal   int64
		tempSpend   time.Duration
		tempSucc    int64
	)
	for {
		tempExecTime := time.Now().Sub(tempStartTs)
		if *reportInterval != 0 && tempExecTime.Seconds() >= float64(*reportInterval) {
			log.Infof("Query: %d, Succ: %d, Faild: %d, Time: %v, Avg response time: %.04fms, QPS: %.02f : \n", tempTotal, tempSucc, tempTotal-tempSucc, tempExecTime, (tempSpend.Seconds()*1000)/float64(tempTotal), float64(tempTotal)/tempExecTime.Seconds())
			tempStartTs = time.Now()
			tempTotal = 0
			tempSpend = 0
			tempSucc = 0
		}
		s, ok := <-statChan
		if !ok {
			break
		}
		total++
		tempTotal++
		if s.succ {
			succ++
			tempSucc++
		}
		spend += s.spend
		tempSpend += s.spend
	}
	execTime := time.Now().Sub(startTs)
	log.Info("\n*************************final result***************************\n")
	log.Infof("Total Query: %d, Succ: %d, Faild: %d, Time: %v, Avg response time: %.04fms, QPS: %.02f : \n", total, succ, total-succ, execTime, (spend.Seconds()*1000)/float64(total), float64(total)/execTime.Seconds())
}

func main() {
	// Start
	log.Info("Start Bench")
	queryChan := make(chan string, queryChanSize)
	wg := sync.WaitGroup{}
	wgStat := sync.WaitGroup{}
	// Start N workers
	timeout := time.Duration(*maxTime) * time.Second
	for i := 0; i < *concurrent; i++ {
		wg.Add(1)
		ctx, _ := context.WithTimeout(context.Background(), timeout)
		go worker(ctx, i, queryChan, &wg)
	}

	wgStat.Add(1)
	startTs := time.Now()
	go statWorker(&wgStat, startTs)

	ctxR, _ := context.WithTimeout(context.Background(), timeout)
	go readQuery(ctxR, queryChan)
	wg.Wait()
	close(statChan)
	wgStat.Wait()
	log.Info("Done!")
}

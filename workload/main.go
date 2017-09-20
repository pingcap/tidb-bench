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
	"context"
	"flag"
	"math/rand"
	"strings"
	"sync"

	"github.com/BurntSushi/toml"
	"github.com/ngaut/log"
)

type Config struct {
	DB         string   `toml:"db"`
	Workload   Workload `toml:"workload"`
	DataSize   int      `toml:"data-size"`
	NumTables  int      `toml:"num-tables"`
	NumWorkers int      `toml:"num-workers"`
}

type Worker struct {
	db *DB
	r  *rand.Rand
	w  *WorkloadRander
}

func NewWorker(db *DB, w *WorkloadRander) *Worker {
	return &Worker{
		db: db,
		r:  NewSeekedRander(),
		w:  w,
	}
}

func (w *Worker) Run(ctx context.Context) {
	for {
		select {
		case <-ctx.Done():
			return
		default:
		}
		var err error
		switch w.w.RandomOP(w.r) {
		case InsertOP:
			err = w.db.Insert(w.r)
		case SelectOP:
			err = w.db.Select(w.r)
		}
		if err != nil && !strings.Contains(err.Error(), "EOF") {
			log.Error(err)
		}
	}
}

func main() {
	cfgFile := flag.String("c", "", "configuration file")
	flag.Parse()

	cfg := new(Config)
	toml.DecodeFile(*cfgFile, cfg)
	log.Infof("Load configuration from %s: %+v", *cfgFile, cfg)

	db, err := NewDB(cfg.DB, cfg.DataSize, cfg.NumTables, cfg.NumWorkers)
	if err != nil {
		log.Fatal(err)
	}

	var wg sync.WaitGroup
	ctx := context.Background()

	for i := 0; i < cfg.NumWorkers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			r := NewWorkloadRander(cfg.Workload)
			w := NewWorker(db, r)
			w.Run(ctx)
		}()
	}

	wg.Wait()
}

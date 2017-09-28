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
	"database/sql"
	"math/rand"

	_ "github.com/go-sql-driver/mysql"
	log "github.com/sirupsen/logrus"
)

type DB struct {
	db         *sql.DB
	tables     []*Table
	generators []Generator
}

func NewDB(dbURL string, dataSize, numTables int) (*DB, error) {
	db, err := sql.Open("mysql", dbURL)
	if err != nil {
		return nil, err
	}

	db.SetMaxOpenConns(1024)
	db.SetMaxIdleConns(1024)

	tables := make([]*Table, numTables)
	generators := make([]Generator, numTables)
	for i := 0; i < numTables; i++ {
		tableID := i + 1
		table, err := NewTable(db, tableID, dataSize)
		if err != nil {
			return nil, err
		}
		maxID, err := table.MaxID()
		if err != nil {
			return nil, err
		}
		tables[i] = table
		generators[i] = NewUniformGenerator(maxID)
		log.Infof("New tableID %d maxID %d", tableID, maxID)
	}

	return &DB{
		db:         db,
		tables:     tables,
		generators: generators,
	}, nil
}

func (db *DB) rand(r *rand.Rand) (*Table, Generator) {
	i := r.Int31n(int32(len(db.tables)))
	return db.tables[i], db.generators[i]
}

func (db *DB) Insert(r *rand.Rand) error {
	t, g := db.rand(r)
	return t.Insert(r, g.NextID())
}

func (db *DB) Select(r *rand.Rand) error {
	t, g := db.rand(r)
	_, err := t.Select(r, g.RandID(r))
	return err
}

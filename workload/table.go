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
	"fmt"
	"math/rand"
	"time"

	log "github.com/sirupsen/logrus"
)

const (
	TableName   = "twtest"
	TableSchema = `(
		id INTEGER UNSIGNED NOT NULL,
        idx INTEGER UNSIGNED NOT NULL,
		pad CHAR(32) NOT NULL DEFAULT '',
        data BLOB,
		PRIMARY KEY(id), INDEX(idx)
	)`
)

func CreateTable(db *sql.DB, table, schema string) error {
	stmt := fmt.Sprintf("CREATE TABLE IF NOT EXISTS `%s` %s", table, schema)
	_, err := db.Exec(stmt)
	return err
}

func NewSeekedRander() *rand.Rand {
	return rand.New(rand.NewSource(time.Now().UnixNano()))
}

const (
	asciiStart = int('a')
	asciiLimit = int('z')
)

func RandomAsciiBytes(r *rand.Rand, size int) []byte {
	data := make([]byte, size)
	for i := range data {
		data[i] = byte(r.Intn(asciiLimit-asciiStart) + asciiStart)
	}
	return data
}

type Table struct {
	db       *sql.DB
	table    string
	dataSize int
}

func NewTable(db *sql.DB, tableID, dataSize int) (*Table, error) {
	tableName := fmt.Sprintf("%s%d", TableName, tableID)
	if err := CreateTable(db, tableName, TableSchema); err != nil {
		return nil, err
	}

	return &Table{
		db:       db,
		table:    tableName,
		dataSize: dataSize,
	}, nil
}

func (t *Table) MaxID() (uint64, error) {
	// TODO: use MAX(id)
	stmt := fmt.Sprintf("SELECT id FROM `%s` ORDER BY id DESC LIMIT 1", t.table)
	rows, err := t.db.Query(stmt)
	if err != nil {
		return 0, err
	}
	defer rows.Close()
	var id uint64
	for rows.Next() {
		if err := rows.Scan(&id); err != nil {
			return 0, err
		}
	}
	return id, nil
}

func (t *Table) Insert(r *rand.Rand, id uint64) error {
	pad := RandomAsciiBytes(r, 32)
	data := RandomAsciiBytes(r, t.dataSize)
	stmt := fmt.Sprintf("INSERT INTO `%s` VALUES (?, ?, ?, ?)", t.table)
	_, err := t.db.Exec(stmt, id, id, pad, data)
	if err != nil {
		log.WithFields(log.Fields{
			"stmt": stmt,
			"id":   id,
		}).Error(err)
		return err
	}
	return nil
}

func (t *Table) Select(r *rand.Rand, id uint64) (bool, error) {
	stmt := fmt.Sprintf("SELECT * FROM `%s` WHERE id = ?", t.table)
	rows, err := t.db.Query(stmt, id)
	if err != nil {
		log.WithFields(log.Fields{
			"stmt": stmt,
			"id":   id,
		}).Error(err)
		return false, err
	}
	defer rows.Close()
	rowsFound := 0
	for rows.Next() {
		rowsFound++
	}
	return rowsFound != 0, nil
}

package main

import (
	"bytes"
	"flag"
	"io/ioutil"
	"log"
	"os"
	"strings"
)

var (
	sqlFile = flag.String("data", "./TENCENT64.log", "SQL data file for bench")
	outFile = flag.String("out", "./bench.sql", "out SQL data file for bench")
)

func init() {
	flag.Parse()
}

func parse() {
	data, err := ioutil.ReadFile(*sqlFile)
	if err != nil {
		log.Fatalf("ReadFile Error: %s", err)
	}
	if len(data) == 0 {
		log.Fatal("file is empty")
	}
	file, err := os.Create(*outFile)
	if err != nil {
		log.Fatalf("Cteate out.sql Error: %s", err)
	}
	defer func() {
		file.Close()
	}()
	dataArr := bytes.Split(data, []byte("Query"))
	for _, v := range dataArr {
		sql := strings.Replace(string(v), "\n", " ", -1)
		sql = strings.Trim(strings.TrimSpace(sql), "\n")
		sqlAry := strings.Split(sql, " ")
		var sqlAryNew []string
		for _, s := range sqlAry {
			if s == "" {
				continue
			}
			sqlAryNew = append(sqlAryNew, s)
		}
		sqlAryNew = sqlAryNew[:len(sqlAryNew)-1]
		sql = strings.Join(sqlAryNew, " ")
		if sql == "" {
			continue
		}
		_, err := file.WriteString(sql + ";" + "\n")
		if err != nil {
			log.Fatalf("Write to out.sql Error: %s", err)
		}
	}
}

func main() {
	log.Println("starting..")
	parse()
	log.Println("end")
}

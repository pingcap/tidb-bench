package main

import (
	"bytes"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

func main() {
	tidbAddrFlag := flag.String("addr", "127.0.0.1", "TiDB's address")
	tidbPortFlag := flag.Int("port", 4000, "TiDB's listening port")
	tpchScaleFlag := flag.Int("scale", 10, "The scale factor of current TPC-H dataset")
	queryDirFlag := flag.String("dir", "./queries", "The directory where the query SQLs are")

	flag.Parse()
	files, err := ioutil.ReadDir(*queryDirFlag)
	if err != nil {
		fmt.Printf("error occurred while reading directory: %v\n", err)
		os.Exit(-1)
	}
	for _, file := range files {
		f := filepath.Join(*queryDirFlag, file.Name())
		fmt.Printf("%v\n", f)
		totCost := time.Duration(0)
		for i := 0; i < 3; i++ {
			cur := time.Now()
			var stderr bytes.Buffer
			cmd := exec.Command("mysql",
				fmt.Sprintf("-h%v", *tidbAddrFlag),
				"-uroot",
				fmt.Sprintf("-P%v", *tidbPortFlag),
				fmt.Sprintf("-Dtpch%v", *tpchScaleFlag),
				fmt.Sprintf("--local_infile"),
				"-e", "source " + f,
			)
			cmd.Stderr = &stderr
			err := cmd.Run()
			if err != nil{
				fmt.Printf("error occurred while running commmand: %v\nstderr: %+v\n", err, stderr.String())
				os.Exit(-1)
			}
			dur := time.Since(cur)
			totCost += dur
			fmt.Printf("%v's %vth run finished\n", file.Name(), i)
		}
		fmt.Printf("%v costs: %v\n", file.Name(), totCost/3)
	}
}

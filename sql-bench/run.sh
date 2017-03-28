#!/bin/bash
./sql-bench -c 128 -pool 100 -addr 127.0.0.1:4000 -db test -u root -data bench.sql -sql-count 1000000000 -max-time 600

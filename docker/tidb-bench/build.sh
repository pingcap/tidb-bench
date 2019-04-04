#!/usr/bin/env bash
set -euo pipefail
pushd ../tidb-sysbench
./build.sh
popd
docker build -t pingcap/tidb-bench .

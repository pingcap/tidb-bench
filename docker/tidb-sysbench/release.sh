#!/usr/bin/env bash
set -euo pipefail

TAG="${1:-"latest"}"
docker tag "pingcap/tidb-sysbench:$TAG" "gcr.io/pingcap-public/pingcap/tidb-sysbench:$TAG"
gcloud docker -- push "gcr.io/pingcap-public/pingcap/tidb-sysbench:$TAG"

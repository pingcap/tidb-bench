FROM golang:1.12.1-alpine3.9 AS goycsb

RUN apk add git build-base \
  && git clone https://github.com/pingcap/go-ycsb $GOPATH/src/github.com/pingcap/go-ycsb \
  && cd $GOPATH/src/github.com/pingcap/go-ycsb \
  && make

FROM alpine:3.9
MAINTAINER PingCAP <cloud@pingcap.com>

COPY --from=pingcap/tidb-sysbench /usr/local/bin/sysbench /usr/local/bin/sysbench
COPY --from=pingcap/tidb-sysbench /usr/local/share/sysbench /usr/local/share/sysbench

COPY --from=dmonakhov/alpine-fio /usr/local/bin/fio /usr/local/bin/fio

COPY --from=goycsb /go/src/github.com/pingcap/go-ycsb/bin/go-ycsb /go-ycsb/bin/go-ycsb
COPY --from=goycsb /go/src/github.com/pingcap/go-ycsb/workloads /go-ycsb/workloads
COPY --from=goycsb /go/src/github.com/pingcap/go-ycsb/tool /go-ycsb/tool

ADD README.md /README.md

CMD ["bash"]

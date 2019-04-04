FROM golang:1.12.1-alpine3.9 AS goycsb

RUN apk add git build-base \
  && git clone https://github.com/pingcap/go-ycsb $GOPATH/src/github.com/pingcap/go-ycsb \
  && cd $GOPATH/src/github.com/pingcap/go-ycsb \
  && make

FROM alpine:3.9
MAINTAINER PingCAP <cloud@pingcap.com>

# Install sysbench
# gcc and mariadb-dev install shared libraries
RUN apk add gcc mariadb-dev \
  && apk add --virtual .build-deps git build-base automake autoconf libtool --update \
  && git clone https://github.com/akopytov/sysbench.git \
  && cd sysbench \
  && ./autogen.sh \
  && ./configure --disable-shared \
  && make \
  && make install \
  && cd .. \
  && rm -r sysbench \
  && apk del .build-deps

# TiDB patch for sysbench data loading (prepare)
RUN apk add --virtual .build-deps wget \
  && wget https://raw.githubusercontent.com/pingcap/tidb-bench/master/sysbench-patch/oltp_common.lua \
  && apk del .build-deps \
  && mv oltp_common.lua /usr/local/share/sysbench/oltp_common.lua

RUN apk add mysql-client
RUN apk add bash
COPY --from=dmonakhov/alpine-fio /usr/local/bin/fio /usr/local/bin/fio

COPY --from=goycsb /go/src/github.com/pingcap/go-ycsb/bin/go-ycsb /go-ycsb/bin/go-ycsb
COPY --from=goycsb /go/src/github.com/pingcap/go-ycsb/workloads /go-ycsb/workloads
COPY --from=goycsb /go/src/github.com/pingcap/go-ycsb/tool /go-ycsb/tool

ADD README.md /README.md

CMD ["bash"]

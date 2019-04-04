FROM alpine:3.9
MAINTAINER PingCAP <cloud@pingcap.com>

# Install sysbench
# gcc and mariadb-dev install shared libraries used at runtime
RUN apk add gcc mariadb-dev

RUN apk add --virtual .build-deps git build-base automake autoconf libtool --update \
  && git clone https://github.com/akopytov/sysbench.git \
  && cd sysbench \
  && git checkout 1.0.17 \
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
  && mv oltp_common.lua /usr/local/share/sysbench/oltp_common.lua \
  && chmod +x /usr/local/share/sysbench/oltp_common.lua

RUN apk add mysql-client
RUN apk add bash

WORKDIR "/usr/local/share/sysbench"
CMD ["sysbench"]

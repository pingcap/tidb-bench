FROM alpine:3.9
LABEL maintainer="PingCAP <cloud@pingcap.com>"

ENV sysbench_version 1.0.17

RUN mkdir /sysbench
WORKDIR /sysbench

# Install sysbench
# gcc and mariadb-dev install shared libraries used at runtime
RUN apk add gcc=8.3.0-r0 mariadb-dev=10.3.13-r0

RUN apk add --no-cache --virtual .build-deps git build-base automake autoconf libtool --update \
  && git clone https://github.com/akopytov/sysbench.git \
  && cd sysbench \
  && git checkout ${sysbench_version} \
  && ./autogen.sh \
  && ./configure --disable-shared \
  && make \
  && make install \
  && cd .. \
  && rm -r sysbench \
  && apk del .build-deps

# TiDB patch for sysbench data loading (prepare)
RUN apk add --no-cache --virtual .build-deps wget \
  && wget https://raw.githubusercontent.com/pingcap/tidb-bench/master/sysbench-patch/oltp_common.lua \
  && apk del .build-deps \
  && mv oltp_common.lua /usr/local/share/sysbench/oltp_common.lua \
  && chmod +x /usr/local/share/sysbench/oltp_common.lua

CMD ["sysbench"]

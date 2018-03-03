# tpcds-kit

The official TPC-DS tools can be found at [tpc.org](http://www.tpc.org/tpc_documents_current_versions/current_specifications.asp).

This version is based on v2.7.0 and has been modified to:

* Allow compilation under macOS (commit [2ec45c5](https://github.com/gregrahn/tpcds-kit/commit/2ec45c5ed97cc860819ee630770231eac738097c))
* Address obvious query template bugs like
  * https://github.com/gregrahn/tpcds-kit/issues/30
  * https://github.com/gregrahn/tpcds-kit/issues/31
  * https://github.com/gregrahn/tpcds-kit/issues/33

## Setup

### Linux

Make sure the required development tools are installed:

Ubuntu:
```sh
sudo apt-get install gcc make flex bison byacc git
```

CentOS/RHEL:
```sh
sudo yum install gcc make flex bison byacc git
```

Then run the following commands to build the tools:

```sh
cd tools
make OS=LINUX
```

### macOS

Make sure the required development tools are installed:

```sh
xcode-select --install
```

Then run the following commands to build the tools:

```sh
cd tools
make OS=MACOS
```

## Using the TPC-DS tools

### Data generation

Data generation is done via `dsdgen`.  See `dsdgen --help` for all options.  If you do not run `dsdgen` from the `tools/` directory then you will need to use the option `-DISTRIBUTIONS /.../tpcds-kit/tools/tpcds.idx`.

Examples:
```sh
cd tools && ./dsdgen -sc $SCALE -f && cd -
```

*load_data.sh* is used to build tools, generate data and load data.

### Query generation

Query generation is done via `dsqgen`.   See `dsqgen --help` for all options.

*tools/genquery.sh* is used to generate queries based on query templetes.

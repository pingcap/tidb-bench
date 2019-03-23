-- Sccsid:     @(#)dss.ddl	2.1.8.1
CREATE TABLE TPCD.NATION  ( N_NATIONKEY  BIGINT NOT NULL,
                            N_NAME       CHAR(25) NOT NULL,
                            N_REGIONKEY  BIGINT NOT NULL,
                            N_COMMENT    VARCHAR(152));

CREATE TABLE TPCD.REGION  ( R_REGIONKEY  BIGINT NOT NULL,
                            R_NAME       CHAR(25) NOT NULL,
                            R_COMMENT    VARCHAR(152));

CREATE TABLE TPCD.PART  ( P_PARTKEY     BIGINT NOT NULL,
                          P_NAME        VARCHAR(55) NOT NULL,
                          P_MFGR        CHAR(25) NOT NULL,
                          P_BRAND       CHAR(10) NOT NULL,
                          P_TYPE        VARCHAR(25) NOT NULL,
                          P_SIZE        BIGINT NOT NULL,
                          P_CONTAINER   CHAR(10) NOT NULL,
                          P_RETAILPRICE DECIMAL(15,2) NOT NULL,
                          P_COMMENT     VARCHAR(23) NOT NULL );

CREATE TABLE TPCD.SUPPLIER ( S_SUPPKEY     BIGINT NOT NULL,
                             S_NAME        CHAR(25) NOT NULL,
                             S_ADDRESS     VARCHAR(40) NOT NULL,
                             S_NATIONKEY   BIGINT NOT NULL,
                             S_PHONE       CHAR(15) NOT NULL,
                             S_ACCTBAL     DECIMAL(15,2) NOT NULL,
                             S_COMMENT     VARCHAR(101) NOT NULL);

CREATE TABLE TPCD.PARTSUPP ( PS_PARTKEY     BIGINT NOT NULL,
                             PS_SUPPKEY     BIGINT NOT NULL,
                             PS_AVAILQTY    BIGINT NOT NULL,
                             PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL,
                             PS_COMMENT     VARCHAR(199) NOT NULL );

CREATE TABLE TPCD.CUSTOMER ( C_CUSTKEY     BIGINT NOT NULL,
                             C_NAME        VARCHAR(25) NOT NULL,
                             C_ADDRESS     VARCHAR(40) NOT NULL,
                             C_NATIONKEY   BIGINT NOT NULL,
                             C_PHONE       CHAR(15) NOT NULL,
                             C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
                             C_MKTSEGMENT  CHAR(10) NOT NULL,
                             C_COMMENT     VARCHAR(117) NOT NULL);

CREATE TABLE TPCD.ORDERS  ( O_ORDERKEY       BIGINT NOT NULL,
                           O_CUSTKEY        BIGINT NOT NULL,
                           O_ORDERSTATUS    CHAR(1) NOT NULL,
                           O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
                           O_ORDERDATE      DATE NOT NULL,
                           O_ORDERPRIORITY  CHAR(15) NOT NULL,  -- R
                           O_CLERK          CHAR(15) NOT NULL,  -- R
                           O_SHIPPRIORITY   BIGINT NOT NULL,
                           O_COMMENT        VARCHAR(79) NOT NULL);

CREATE TABLE TPCD.LINEITEM ( L_ORDERKEY    BIGINT NOT NULL,
                             L_PARTKEY     BIGINT NOT NULL,
                             L_SUPPKEY     BIGINT NOT NULL,
                             L_LINENUMBER  BIGINT NOT NULL,
                             L_QUANTITY    DECIMAL(15,2) NOT NULL,
                             L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,
                             L_DISCOUNT    DECIMAL(15,2) NOT NULL,
                             L_TAX         DECIMAL(15,2) NOT NULL,
                             L_RETURNFLAG  CHAR(1) NOT NULL,
                             L_LINESTATUS  CHAR(1) NOT NULL,
                             L_SHIPDATE    DATE NOT NULL,
                             L_COMMITDATE  DATE NOT NULL,
                             L_RECEIPTDATE DATE NOT NULL,
                             L_SHIPINSTRUCT CHAR(25) NOT NULL,  -- R
                             L_SHIPMODE     CHAR(10) NOT NULL,  -- R
                             L_COMMENT      VARCHAR(44) NOT NULL);


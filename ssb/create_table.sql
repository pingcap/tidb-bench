create table part (
    p_partkey bigint,
    p_name varchar(30),
    p_mfgr char(10),
    p_category char(10),
    p_brand1 char(10),
    p_color varchar(20),
    p_type varchar(30),
    p_size bigint,
    p_container char(10),
    primary key(p_partkey)
);

create table supplier(
    s_suppkey bigint,
    s_name char(30),
    s_address varchar(30),
    s_city char(20),
    s_natios_nationn char(20),
    s_region char(20),
    s_phone char(20),
    primary key(s_suppkey)
);

create table customer(
    c_custkey bigint,
    c_name varchar(30),
    c_address varchar(30),
    c_city char(20),
    c_nation char(20),
    c_regioc_regionn char(20),
    c_phone char(20),
    c_mktsegment char(20),
    primary key(c_custkey)
);

create table date(
    d_datekey bigint,
    d_date char(20),
    d_dayofweek char(10),
    d_month char(10),
    d_year bigint,
    d_yearmonthnum bigint,
    d_yearmonth char(10),
    d_daynuminmonth bigint,
    d_daynuminyear bigint,
    d_monthnuminyear bigint,
    d_weeknuminyear bigint,
    d_sellingseason char(20),
    d_lastdayinweekfl bigint,
    d_lastdayinmonthfl bigint,
    d_holidayfl bigint,
    d_weekdayfl bigint,
    primary key(d_datekey)
);

create table lineorder (
    lo_orderkey bigint,
    lo_linenumber bigint,
    lo_custkey bigint,
    lo_partkey bigint,
    lo_suppkey bigint,
    lo_orderdate bigint,
    lo_orderpriority char(20),
    lo_shippriority char(1),
    lo_quantity bigint,
    lo_extendedprice bigint,
    lo_ordtotalprice bigint,
    lo_discount bigint,
    lo_revenue bigint,
    lo_supplycost bigint,
    lo_tax bigint,
    lo_commitdate bigint,
    lo_shipmode char(10),
    primary key(lo_orderkey, lo_linenumber),
    constraint foreign key lineorder_fk1(lo_custkey) references customer(c_custkey),
    constraint foreign key lineorder_fk2(lo_partkey) references part(p_partkey),
    constraint foreign key lineorder_fk3(lo_suppkey) references supplier(s_suppkey),
    constraint foreign key lineorder_fk4(lo_orderdate) references date(d_datekey),
    constraint foreign key lineorder_fk5(lo_commitdate) references date(d_datekey)
);

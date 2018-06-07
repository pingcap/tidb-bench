Note: In our research paper we use the SSB instead of SSBM
Version of 2/28/10:
Cardinality of supplier fixed to follow benchmark spec: now 2000*SF
 (previously was 10000*SF, in error): line 226, driver.c
Type of time value changed from long to time_t (now 64 bits on Windows):
 line 688, build.c
Building in Visual Studio 2008:
  Use Win32 console project, not using precompiled headers,
  in Properties>C/C++>CommandLine, additional options:
   /D "SSBM" /D "DBNAME" /D "DB2"   (for DB2)
Building using makefile_win:  set for DB2 build:
  nmake -f makefile_win
  (Change DATABASE symbol for other database)

SSBM dbgen readme:

SSBM is based on TPC-H dbgen source. The coding style and architecture
follows the TPCH dbgen. The original TPCH dbgen code stays untouched and
all new code related to SSBM dbgen follow the "#ifdef SSBM" statements.

For original detailed TPC-H documentation, please refer TPCH_README
document under the same directory. Here we just list few things that
are specific to SSBM.


1. How is SSBM DBGEN built?

Same idea as TPCH dbgen setup, which requires user to create an
appropriate makefile, using makefile.suite as a basis. Make sure to
use "SSBM" for the workload variable.

Type "make" to compile and to generate the SSBM dbgen executable.
Please refer to Porting.Notes for more details and for
suggested compile time options.

Note: If you want to generate the data files to a diffent directory, you should
copy the dbgen executable as well as the dists.dss file to that directory.

2. How to generate SSBM data files?
To generate the dimension tables:

(customer.tbl)
dbgen -s 1 -T c

(part.tbl)
dbgen -s 1 -T p

(supplier.tbl)
dbgen -s 1 -T s

(date.tbl)
dbgen -s 1 -T d

(fact table lineorder.tbl)
dbgen -s 1 -T l

(for all SSBM tables)
dbgen -s 1 -T a

To generate the refresh (insert/delete) data set:
(create delete.[1-4] and lineorder.tbl.u[1-4] with refreshing fact 0.05%)
dbgen -s 1 -r 5 -U 4

   where "-r 5" specifies refreshin fact n/10000
         "-U 4" specifies 4 segments for deletes and inserts

At this moment there is no QGEN for SSBM. So
the command line options related to those features won't apply.

3. What are the changes upon TPC-H dbgen

changes made upon original TPC-H dbgen

1. removed snowflake tables such as nation and region (done)
2. removed the partsupply table (done)
3. removed the order table (done)
4. renamed the fact table as Lineorder and added/removed many fields
( done)
5. added the date dimension table (done)
6. adding and removing fields in dimension tables (done)
7. have data cross reference for supplycost, revenue in lineorder (done)
8. apply the refreshing only to lineorder table (done)

The command line option keeps the same as TPC-H dbgen (The -T options
are changed to reflect different set of tables)

===================== End of README ========================================


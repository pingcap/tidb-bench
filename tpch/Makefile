tbl: dbgen
	cd dbgen && ./dbgen -s 1
dbgen:
	cd dbgen; make;
load:
	sh gen_load_script.sh
	mysql -h 127.0.0.1 -P 4000 -u root -D test < dss.sql
	nohup mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D tpch < CUSTOMER.sql&
	nohup mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D tpch < LINEITEM.sql&
	nohup mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D tpch < PART.sql&
	nohup mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D tpch < NATION.sql&
	nohup mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D tpch < ORDERS.sql&
	nohup mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D tpch < PARTSUPP.sql&
	nohup mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D tpch < REGION.sql&
	nohup mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D tpch < SUPPLIER.sql&

cleansql:
	mv dss.sql dss.sqt
	rm -rf *.sql
	mv dss.sqt dss.sql
cleantbl:
	cd dbgen; make clean; rm -f *.tbl

.PHONY: dbgen load clean tbl

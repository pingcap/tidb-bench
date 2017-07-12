tbl: dbgen
	cd dbgen && ./dbgen -s 1
dbgen:
	cd dbgen; make;
load:
	sh gen_load_script.sh
	mysql -h 127.0.0.1 -P 4000 -u root -D test < dss.sql
	mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D test < CUSTOMER.sql&
	mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D test < LINEITEM.sql&
	mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D test < PART.sql&
	mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D test < PART.sql&
	mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D test < NATION.sql&
	mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D test < ORDERS.sql&
	mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D test < PARTSUPP.sql&
	mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D test < REGION.sql&
	mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D test < SUPPLIER.sql&

clean:
	mv dss.sql dss.sqt
	rm -rf *.sql
	mv dss.sqt dss.sql
	cd dbgen; make clean; rm -f *.tbl

.PHONY: dbgen load clean tbl

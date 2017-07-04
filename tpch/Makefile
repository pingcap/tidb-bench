tbl: dbgen
	cd dbgen && ./dbgen -s 1
dbgen:
	cd dbgen; make;
load:
	sh gen_load_script.sh
	mysql -h 127.0.0.1 -P 4000 -u root -D test < dss.sql
	mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D test < loaddata.sql

clean:
	rm -f loaddata.sql
	cd dbgen; make clean; rm -f *.tbl

.PHONY: dbgen load clean tbl

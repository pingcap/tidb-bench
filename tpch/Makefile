tbl:
	cd tpch & make;
load:
	sh gen_load_script.sh
	mysql -h 127.0.0.1 -P 4000 -u root -D test < dss.sql
	mysql -h 127.0.0.1 -P 4000 -u root -D test < loaddata.sql

clean:
	cd dbgen; make clean

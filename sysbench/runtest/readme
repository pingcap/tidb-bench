# running sysbench

1、modify the conf.sh to confirm the database's connection information is right;
2、use prepare to create database and load the data into table  one by one; or use parallel-prepare.sh to create database and load the data into table parallel;
3、start running the sysbench after load data finished. for example: ./select.sh or ./oltp.sh
4、get the result after finished.


# running sysbench automatically
# user can make the plan to run sysbench automatically.
1、confirm the conf.sh.toml, the connection of database info;
2、copy all the sysbench file to different host, same path, and chmod +x *.sh;
3、start run sysbench : ./runtest.sh
4、get the all report : ./getreport.sh

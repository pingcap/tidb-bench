#!/usr/bin/perl
#
# generate a workload with sequential reads by selecting all records from
# the eight tables
#

my $output = "./tablescan.sqls";
open OUTPUT, '>', $output or die "failed to create output file\n$!\n";

print OUTPUT "START TRANSACTION;\n";

my @tables = ("customer", "region", "nation", "part", "partsupp", "supplier",
		"lineitem", "orders");
foreach my $table (@tables){
	print OUTPUT "select * from $table;\n";
}

print OUTPUT "COMMIT;\n";

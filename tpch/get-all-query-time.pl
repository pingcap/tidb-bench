#!/usr/bin/perl -w
use strict;
use warnings;
#
# Execute all random queries, except 18.sql
#

my $output = "query-time.log";

for (my $i = 20; $i <= 22; $i++){

	# skip query 18 because it takes long time
	# next if $i == 18;

	print "query $i\n";
	system("echo query: $i >> $output");
	system("./get-query-time.pl queries/$i.sql >> $output");
}

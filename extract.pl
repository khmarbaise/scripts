#!/usr/bin/perl -w
#
# ====================================================================
#               ---::: Remove Oldes Files (rof) :::---
# ====================================================================
#
# ====================================================================
#          (c) Copyright by Karl Heinz Marbaise 2005
#                          Release 0.0.3
# ====================================================================
#
use strict;
use Getopt::Long;
use Data::Dumper;

my $mongrel_status = `mongrel_cluster_ctl status`;
my $top_output = `top -n 1 -d 0 -b`;

my $top_head = `echo "$top_output" |head -7`;
my $top_mongrel = `echo "$top_output" |grep "mongrel"`;

#print "top_head: $top_head\n";
#print "Mongrel_status: $mongrel_status\n";

#print "$top_mongrel";

my @top_mongrel = split("\n", $top_mongrel);
chomp(@top_mongrel);
for my $line (@top_mongrel) {
	print "Zeile: $line\r";
}
exit 0;

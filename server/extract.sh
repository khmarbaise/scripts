#!/bin/bash
# Extract all the lines with mongrel_rails in it...from top...
MONGREL_STATUS=`mongrel_cluster_ctl status`
# Extract the PID's of the entries.
#echo "$MONGREL_STATUS"| grep "found mongrel_rails" | cut -d":" -f2 | cut -d"," -f2
#
TOP=`top -n 1 -d 0 -b`
echo "$TOP" |head -7
echo "$TOP" |grep "mongrel"

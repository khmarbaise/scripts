#!/bin/bash
DATE=`date  +%Y%m%d%H%M%S`
NUMBER_OF_DENIES=`cat /var/log/syslog | grep "iptables denied:" | wc -l`
LIST_OF_IPS=`cat /var/log/syslog | grep "iptables denied:" | tr -s " " | cut -d" " -f12 | cut -d "=" -f2 | sort | uniq | tr "\\n" "," | sed 's/,$//'`

echo "${DATE}|${NUMBER_OF_DENIES}|${LIST_OF_IPS}"


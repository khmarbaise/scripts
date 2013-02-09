#!/bin/bash
cat $1  | grep -v "root/bin/monitor" | grep -v "timeserver:" | grep -v "Daily Backup" | grep -v "/root/bin/timing.sh" | grep -v "STATS: dropped 0" | grep -v "/root/bin/backup.sh" | grep -v "/root/bin/cleanarea.sh" | grep -v "apachectl" 

#!/bin/bash
DISK_SDA1_RRD=/usr/share/rrdtool/disk_sda1.rrd
DISK_SDA3_RRD=/usr/share/rrdtool/disk_sda3.rrd
VHOST=/usr/local/vhosts/monitor
RRDTOOL=/usr/bin/rrdtool

case $1 in (create)
		$RRDTOOL create $DISK_SDA1_RRD --step 300 \
			DS:sda1:GAUGE:600:0:U \
			RRA:AVERAGE:0.5:1:432 \
			RRA:AVERAGE:0.5:1:2016 \
			RRA:AVERAGE:0.5:3:2880 \
			RRA:AVERAGE:0.5:12:8640;
		$RRDTOOL create $DISK_SDA3_RRD --step 300 \
			DS:sda3:GAUGE:600:0:U \
			RRA:AVERAGE:0.5:1:432 \
			RRA:AVERAGE:0.5:1:2016 \
			RRA:AVERAGE:0.5:3:2880 \
			RRA:AVERAGE:0.5:12:8640;;
	(update)
		KHDA3=`df|grep sda1|tr -s [:blank:]| cut -f3 -d" "`
		HDA3=$(expr $KHDA3 \* 1024)
		KHDA5=`df|grep sda3|tr -s [:blank:]| cut -f3 -d" "`
		HDA5=$(expr $KHDA5 \* 1024)
		$RRDTOOL update $DISK_SDA1_RRD N:$HDA3;
		$RRDTOOL update $DISK_SDA3_RRD N:$HDA5;;
	(graph)
		# 
		nice -n 19 \
			$RRDTOOL graph $VHOST/sda1.png  -b 1024 --start -129600 \
			-t "Belegung sda1 (EXT2)" --vertical-label "Bytes belegt" -w 600 -h 100 \
			DEF:sda1=$DISK_SDA1_RRD:sda1:AVERAGE AREA:sda1#00ff00:"belegter Platz" > /dev/null;
		nice -n 19 \
			$RRDTOOL graph $VHOST/sda1-7.png -b 1024 --start -604800 \
			-t "Belegung sda1 (EXT2)" --vertical-label "Bytes belegt" -w 600 -h 100 \
			DEF:sda1=$DISK_SDA1_RRD:sda1:AVERAGE AREA:sda1#00ff00:"belegter Platz" > /dev/null;
		# sda3
		nice -n 19 \
			$RRDTOOL graph $VHOST/sda3.png -b 1024 --start -129600 \
				-t "Belegung sda3 (XFS)" --vertical-label "Bytes belegt" -w 600 -h 100 \
				DEF:sda3=$DISK_SDA3_RRD:sda3:AVERAGE AREA:sda3#00ff00:"belegter Platz" > /dev/null;
		nice -n 19 \
			$RRDTOOL graph $VHOST/sda3-7.png -b 1024 --start -604800 \
				-t "Belegung sda3 (XFS)" --vertical-label "Bytes belegt" -w 600 -h 100 \
				DEF:sda3=$DISK_SDA3_RRD:sda3:AVERAGE AREA:sda3#00ff00:"belegter Platz" > /dev/null;;
	(*)
	echo "Invalid option.";;
esac


#!/bin/bash
RAMSWAP_RRD=/usr/share/rrdtool/ramswap.rrd
VHOST=/usr/local/vhosts/monitor
RRDTOOL=/usr/bin/rrdtool

case $1 in (create)
		$RRDTOOL \
		create $RAMSWAP_RRD --step 60 \
		DS:fram:GAUGE:120:U:U \
		DS:fswap:GAUGE:120:U:U \
		RRA:AVERAGE:0.5:1:2160 \
		RRA:AVERAGE:0.5:5:2016 \
		RRA:AVERAGE:0.5:15:2880 \
		RRA:AVERAGE:0.5:60:8760;;
	(update)
		# die Daten rund um RAM und SWAP kommen aus /proc/meminfo
		# freier RAM
		FRAM=`grep MemFree: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`
		# freier Swap
		FSWAP=`grep SwapFree: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`
		# rein damit in die RRD
		$RRDTOOL update $RAMSWAP_RRD N:$FRAM:$FSWAP;;
	(graph)
		SWAPT=`grep SwapTotal: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`
		MEMT=`grep MemTotal: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`
		MEMTOTAL=$(expr $MEMT \* 1024)
		SWAPTOTAL=$(expr $SWAPT \* 1024)
		# 36 Stunden - RAM und Swap in einen
		nice -n 19 $RRDTOOL graph $VHOST/ramswap.png \
		-b 1024 --start -129600 -a PNG -t "RAM und SWAP" --vertical-label "Bytes" -w 700 -h 100 \
		DEF:fram=$RAMSWAP_RRD:fram:AVERAGE \
		DEF:fswap=$RAMSWAP_RRD:fswap:AVERAGE \
		CDEF:framb=fram,1024,* \
		CDEF:fswapb=fswap,1024,* \
		CDEF:bram=$MEMTOTAL,framb,- \
		CDEF:bswap=$SWAPTOTAL,fswapb,- \
		CDEF:brammb=bram,1048576,/ \
		CDEF:frammb=framb,1048576,/ \
		CDEF:bswapmb=bswap,1048576,/ \
		CDEF:fswapmb=fswapb,1048576,/ \
		VDEF:brammb1=brammb,LAST \
		VDEF:frammb1=frammb,LAST \
		VDEF:bswapmb1=bswapmb,LAST \
		VDEF:fswapmb1=fswapmb,LAST \
		AREA:bram#99ffff:"belegter RAM,  letzter\: " GPRINT:brammb1:"%7.3lf MB " \
		LINE1:framb#ff0000:"freier RAM,  letzter\: " GPRINT:frammb1:"%7.3lf MB     Grafik erzeugt am\n" \
		LINE1:bswap#000000:"belegter SWAP, letzter\: " GPRINT:bswapmb1:"%7.3lf MB " \
		LINE1:fswapb#006600:"freier SWAP, letzter\: " GPRINT:fswapmb1:"%7.3lf MB    $(/bin/date "+%d.%m.%Y %H\:%M\:%S")" > /dev/null;
		# 7 Tage - RAM und Swap in einen
		nice -n 19 $RRDTOOL graph $VHOST/ramwoc.png \
		-b 1024 --start -604800 -a PNG -t "RAM und SWAP" --vertical-label "Bytes" -w 700 -h 100 \
		DEF:fram=$RAMSWAP_RRD:fram:AVERAGE \
		DEF:fswap=$RAMSWAP_RRD:fswap:AVERAGE \
		CDEF:framb=fram,1024,* \
		CDEF:fswapb=fswap,1024,* \
		CDEF:bram=$MEMTOTAL,framb,- \
		CDEF:bswap=$SWAPTOTAL,fswapb,- \
		AREA:bram#99ffff:"belegter RAM" \
		LINE1:framb#ff0000:"freier RAM" \
		LINE1:bswap#000000:"belegter SWAP" \
		LINE1:fswapb#006600:"freier SWAP" > /dev/null;;
	(*)
	echo "Invalid option.";;
esac

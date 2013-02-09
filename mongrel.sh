#!/bin/bash
MONGREL_RRD=/usr/share/rrdtool/mongrel.rrd
VHOST=/usr/local/vhosts/monitor
RRDTOOL=/usr/bin/rrdtool

case $1 in (create)
		$RRDTOOL create $MONGREL_RRD -s 60 \
		DS:load1:GAUGE:180:0:U \
		DS:load5:GAUGE:180:0:U \
		DS:load15:GAUGE:180:0:U \
		DS:cpuuser:COUNTER:180:0:100 \
		DS:cpunice:COUNTER:180:0:100 \
		DS:cpusystem:COUNTER:180:0:100 \
		RRA:AVERAGE:0.5:1:1440 \
		RRA:AVERAGE:0.5:1440:1 \
		RRA:MIN:0.5:1440:1 \
		RRA:MAX:0.5:1440:1;;
	(update)
		$RRDTOOL update $MONGREL_RRD \
		N:`/bin/sed "s/\([0-9]\\.[0-9]\\{2\\}\)\ \([0-9]\\.[0-9]\\{2\\}\)\ \([0-9]\\.[0-9]\\{2\\}\).*/\1:\2:\3/" < /proc/loadavg`:`/usr/bin/head -n 1 /proc/stat | /bin/sed "s/^cpu\ \+\([0-9]*\)\ \([0-9]*\)\ \([0-9]*\).*/\1:\2:\3/"`;;
	(graph)
		$RRDTOOL graph $VHOST/load.png \
		-Y -u 1.1 -l 0 -L 5 -v "Load" -w 700 -h 300 -t "Load & CPU stats - `/bin/date`" \
		-c ARROW\#000000 -x MINUTE:30:MINUTE:30:HOUR:1:0:%H \
		DEF:load1=$MONGREL_RRD:load1:AVERAGE \
		DEF:load5=$MONGREL_RRD:load5:AVERAGE \
		DEF:load15=$MONGREL_RRD:load15:AVERAGE \
		DEF:user=$MONGREL_RRD:cpuuser:AVERAGE \
		DEF:nice=$MONGREL_RRD:cpunice:AVERAGE \
		DEF:sys=$MONGREL_RRD:cpusystem:AVERAGE \
		CDEF:cpu=user,nice,sys,+,+ \
		CDEF:reluser=load15,user,100,/,* \
		CDEF:relnice=load15,nice,100,/,* \
		CDEF:relsys=load15,sys,100,/,* \
		CDEF:idle=load15,100,cpu,-,100,/,* \
		HRULE:1\#000000 \
		COMMENT:"	" \
		AREA:reluser\#FF0000:"CPU user" \
		STACK:relnice\#00AAFF:"CPU nice" \
		STACK:relsys\#FFFF00:"CPU system" \
		STACK:idle\#00FF00:"CPU idle" \
		COMMENT:"	\j" \
		COMMENT:"	" \
		LINE1:load1\#000FFF:"Load average 1 min" \
		LINE2:load5\#000888:"Load average 5 min" \
		LINE3:load15\#000000:"Load average 15 min" \
		COMMENT:"	\j" \
		COMMENT:"\j" \
		COMMENT:"	" \
		GPRINT:load15:MIN:"Load 15 min minimum\: %lf" \
		GPRINT:load15:MAX:"Load 15 min maximum\: %lf" \
		GPRINT:load15:AVERAGE:"Load 15 min average\: %lf" \
		COMMENT:"	\j" \
		COMMENT:"	" \
		GPRINT:cpu:MIN:"CPU usage minimum\: %lf%%" \
		GPRINT:cpu:MAX:"CPU usage maximum\: %lf%%" \
		GPRINT:cpu:AVERAGE:"CPU usage average\: %lf%%" \
		COMMENT:"	\j" >/dev/null;
		#
		$RRDTOOL graph $VHOST/cpu.png \
		-Y -r -u 100 -l 0 -L 5 -v "CPU usage" -w 700 -h 300 -t "Bifroest CPU stats - `/bin/date`" \
		-c ARROW\#000000 -x MINUTE:30:MINUTE:30:HOUR:1:0:%H \
		DEF:user=$MONGREL_RRD:cpuuser:AVERAGE \
		DEF:nice=$MONGREL_RRD:cpunice:AVERAGE \
		DEF:sys=$MONGREL_RRD:cpusystem:AVERAGE \
		CDEF:idle=100,user,nice,sys,+,+,- \
		COMMENT:"	" \
		AREA:user\#FF0000:"CPU user" \
		STACK:nice\#000099:"CPU nice" \
		STACK:sys\#FFFF00:"CPU system" \
		STACK:idle\#00FF00:"CPU idle" \
		COMMENT:"	\j" >/dev/null;;
	(*)
	echo "Invalid option.";;
esac


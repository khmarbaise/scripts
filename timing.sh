#!/bin/bash
# ptbtime0.ptb.de liefert unknown host
TIMESERVER=ptbtime2.ptb.de
logger -t timeserver "starting update on Server $TIMESERVER"
UPDATE=`/usr/sbin/ntpdate $TIMESERVER`
logger -t timeserver "$UPDATE"
logger -t timeserver "update done."


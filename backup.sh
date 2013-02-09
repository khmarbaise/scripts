#!/bin/bash
# This script has to be called after midnight !!
# Usualy e.g. one minute after midnight
if [ -z $1 ]; then
	DATE="yesterday"
else
	DATE=$1
fi
#
#
SCRIPTPATH=/root/bin
#
# This is needed cause we rotate log files on daily base
#
# Get week number of the date which is needed
WEEKNRYESTERDAY=`date --date="$DATE" +%W`
MONTHYESTERDAY=`date --date="$DATE" +%m`
# The number of the week of today
WEEKNRTODAY=`date +%W`
# Get day number
DAYNRYESTERDAY=`date --date="$DATE" +%j`
DAYYESTERDAY=`date --date="$DATE" +%d`
# this is needed, cause if we have the first of january of the next year
# we don't get the logs of yesterday (last year) cause
# cronlog is running on year/day base
YEARYESTERDAY=`date --date="$DATE" +%Y`
#
EXTENSION=`date --date="$DATE" +%H%M%S`
# Where the VHOSTs live..
BASEPATHVHOST="/usr/local/vhosts";
# Where all the Log-Files live...
BASEPATHLOGS="/var/log";
#
BASEPATHCONF="/usr/local/vhosts/ /usr/local/repos /etc/ /root/bin/ /root/.ssh/";
#
#
BACKUPPATH="/usr/backup";
#
MYSQLBASE="/usr/bin/";
#
FTPBACKUPSERVER=minden205.myftpbackup.com
#
#
# Vhosts einträge
# /usr/local/vhosts/*
# Log Files
# /var/log/apache2/*
# aktuelle Apache Configuration
# /etc/apache2/*
# Datenbank Sicherung
# mysqldump ...
#
# Subversion Repos ? Noch nicht
#
FILE_LOGFILE_BACKUP=logfiles-$YEARYESTERDAY$MONTHYESTERDAY$DAYYESTERDAY-$EXTENSION.tar.gz 
FILE_VHOSTS_BACKUP=vhosts-$YEARYESTERDAY$MONTHYESTERDAY$DAYYESTERDAY-$EXTENSION.tar.gz
FILE_ETCCONF_BACKUP=etcconf-$YEARYESTERDAY$MONTHYESTERDAY$DAYYESTERDAY-$EXTENSION.tar.gz 
FILE_DATABASE_BACKUP=db-$YEARYESTERDAY$MONTHYESTERDAY$DAYYESTERDAY 
FILE_DATABASE_BACKUPGZ=db-$YEARYESTERDAY$MONTHYESTERDAY$DAYYESTERDAY.gz
REPOS_BACKUP=repos-$YEARYESTERDAY$MONTHYESTERDAY$DAYYESTERDAY.tar.gz
#
MYSQLUSER="root"
MYSQLPASSWORD=""
#
# Dump MySQL Database and compress the result
logger -t"Daily Backup" "Starting MySQL backup."
# All tables will be locked during the dump operation
$MYSQLBASE/mysqldump --lock-all-tables --all-databases --add-drop-table -c --user=$MYSQLUSER --password=$MYSQLPASSWORD >$BACKUPPATH/$FILE_DATABASE_BACKUP 2>$SCRIPTPATH/mysqldump.log
gzip -9 $BACKUPPATH/$FILE_DATABASE_BACKUP
logger -t"Daily Backup" "MySQL backup done."
#
#echo "MYSQLUSER=$MYSQLUSER"
#echo "MYSQLPASSWORD=$MYSQLPASSWORD"
#exit 1;
#
logger -t"Daily Backup" "Starting logfile backup."
tar -czf $BACKUPPATH/$FILE_LOGFILE_BACKUP $BASEPATHLOGS
logger -t"Daily Backup" "Logfile backup done."
logger -t"Daily Backup" "Starting VHOSTS backup."
tar --exclude="ruby_sess.*" --exclude="production.log" -czf $BACKUPPATH/$FILE_VHOSTS_BACKUP $BASEPATHVHOST
logger -t"Daily Backup" "VHOSTS backup done."
#
logger -t"Daily Backup" "Starting Repository backup."
tar -czf $BACKUPPATH/$REPOS_BACKUP /usr/local/repos
logger -t"Daily Backup" "Repository backup done."
#
logger -t"Daily Backup" "Starting $BASEPATHCONF backup."
tar --exclude="ruby_sess.*" --exclude="production.log" -czf $BACKUPPATH/$FILE_ETCCONF_BACKUP $BASEPATHCONF
logger -t"Daily Backup" "$BASEPATHCONF backup done."


#
# Transfer to backup space
#
# do transfer
# Remove files from Backup Space on local machine.
FTPUSER=`cat $SCRIPTPATH/ftpuser`
FTPPASSWORD=`cat $SCRIPTPATH/ftppassword`
#
logger -t"Daily Backup" "Starting transfer to backup space."
ncftpput -u $FTPUSER -p $FTPPASSWORD $FTPBACKUPSERVER / $BACKUPPATH/{$REPOS_BACKUP,$FILE_LOGFILE_BACKUP,$FILE_VHOSTS_BACKUP,$FILE_ETCCONF_BACKUP,$FILE_DATABASE_BACKUPGZ} >>$BASEPATHLOGS/ncftpput.log
logger -t"Daily Backup" "Transfer to backup space done."


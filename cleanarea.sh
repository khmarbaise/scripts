#!/bin/bash
ROF=/root/bin/rof.pl
DIR=/usr/backup
P1=db-*.gz
P2=vhosts-*.tar.gz
P3=logfiles-*.tar.gz
P4=repos-*.tar.gz
P5=etcconf-*.tar.gz
#
print () {
    for i in $1; do
        echo ${i}
    done
}
#
deletefiles () {
    for i in $1; do
        echo -n "removing ${i}"
        rm -f ${i}
        echo "...done."
    done
}
#
D1=`$ROF --pattern="$P1" --directory=$DIR`
D2=`$ROF --pattern="$P2" --directory=$DIR`
D3=`$ROF --pattern="$P3" --directory=$DIR`
D4=`$ROF --pattern="$P4" --directory=$DIR`
D5=`$ROF --pattern="$P5" --directory=$DIR`

print "$D1"
print "$D2"
print "$D3"
print "$D4"
print "$D5"
deletefiles "$D1"
deletefiles "$D2"
deletefiles "$D3"
deletefiles "$D4"
deletefiles "$D5"

#!/bin/bash
#
# Idea:
#  Sometime in the past i did the following:
#    export PATH=/xyz/bin:$PATH
#  But now back in the current time i would like to move
#  that.
#    So how to do this?
#
#  So that's the idea for this script to simplify this process.
#
#  Usage:
#    
#
#
ENTRIES=`echo $PATH | tr ':' ' '`
for i in $ENTRIES; do
  echo "Path: ${i}";
done

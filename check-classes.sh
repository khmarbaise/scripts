#!/bin/bash
#
# An other solution might be to use file instead.
#  find -type f -name "*.class" | xargs file | grep -v "compiled Java class data, version 50.0 (Java 1.6)"
#
for i in `find . -name \*class`
do
  v=`od -h $i | head -1 | awk '{print $5}'`
  if [ $v != "3100" ]
  then
    echo "Class $i has version $v, expected 3100"
    exit -1
  fi
done

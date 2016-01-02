#!/bin/bash
WORDS=$(cat text.txt | cut -d" " -f1 | sort -u)
for i in $WORDS; do
  echo -n "$i:"
  VALUE=`cat text.txt | egrep "^${i}\s+" | cut -d' ' -f2 | paste -sd+ - | bc -l`
  echo " ${VALUE}"
done

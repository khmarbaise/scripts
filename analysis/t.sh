#!/bin/bash
WORDS=$(cat text.txt | sort -u | cut -d" " -f1 | uniq)
for i in $WORDS; do
  echo -n "$i:"
  VALUE=`cat text.txt | egrep "^${i}\s+" | cut -d' ' -f2 | paste -sd+ - | bc -l`
  echo " ${VALUE}"
done

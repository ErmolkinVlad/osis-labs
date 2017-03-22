#!/bin/bash
#Variant: 3

file=$1
result=dump.txt


if [ -f "$file" ]; then
  printf "File: $file\n\n" > $result
  hd=`hexdump $file`
  printf "Hex Dump:\n$hd\n\n" >> $result
  owner=`ls -l $file | awk '{ print $3 }'`
  printf "Owner: $owner\n\n" >> $result
  printf "Date: $(date)" >> $result
else
  echo "No such file."
fi
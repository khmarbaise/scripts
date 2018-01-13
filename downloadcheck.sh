#!/bin/bash
# downloadcheck.sh filename
# Compare md5 against filename.md5 
# Compare sha1 against filename.sha1
GENERATED_MD5=$(openssl md5 $1 | cut -d " " -f2)
GENERATED_SHA1=$(openssl sha1 $1 | cut -d " " -f2)
READ_MD5=$(cat $1.md5)
READ_SHA1=$(cat $1.sha1)
echo "Filename: $1.."
echo "   SHA1 Checksum :"
echo "        generated : ${GENERATED_SHA1}"
echo "             read : ${READ_SHA1} from file $1.sha1"
echo -n "   Compare Result : "
if [ "$GENERATED_SHA1" == "${READ_SHA1}" ]; then
  printf '\e[0;32mok.\e[0m\n'
else
  printf '\e[0;31mNOT OK!.\e[0m\n'
fi
echo ""
echo "   MD5 Checksum :"
echo "        generated : ${GENERATED_MD5}"
echo "             read : ${READ_MD5} from file $1.md5"
echo -n "   Compare Result : "
if [ "$GENERATED_MD5" == "${READ_MD5}" ]; then
  printf '\e[0;32mok.\e[0m\n'
else
  printf '\e[0;31mNOT OK!.\e[0m\n'
fi

#!/bin/bash
#
# usage: 
#  Call this script on a branch which has been
#  rebased and must be pushed with --force-with-lease
#
# git push origin --force-with-lease MENFORCER-305
# 
# Identify branch on which we are.
BRANCH=$(git symbolic-ref --short HEAD)
if [ $? -ne 0 ]; then
  echo "We are not on any branch. (detached?)"
  exit 1;
fi
if [ "$BRANCH" == "master" ]; then
  echo "We are on master."
  exit 2;
fi
git push origin --force-with-lease $BRANCH

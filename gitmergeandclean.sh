#!/bin/bash
#
# usage: 
#  Call this script after you have switched onto the branch
#  you would like to merge back into master.
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
git co master
git merge $BRANCH
git push origin master
git push origin --delete $BRANCH
git branch -d $BRANCH

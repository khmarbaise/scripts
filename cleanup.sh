#!/bin/bash
# Remove all files which are related to Eclipse configuration
#
find -type f -name ".classpath" | xargs rm
find -type f -name ".project" | xargs rm
find -type d -name ".settings" | xargs rm -fr

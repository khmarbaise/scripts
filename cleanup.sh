#!/bin/bash
# Remove all files which are related to Eclipse configuration
#
find -type f -name ".classpath" | xargs rm -f
find -type f -name ".project" | xargs rm -f
find -type d -name ".settings" | xargs rm -fr
find -type d -name ".metadata" | xargs rm -fr

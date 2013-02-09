#!/bin/bash
pushd /usr/local/vhosts/redmine
ruby script/server -e production -p 80 -d
popd

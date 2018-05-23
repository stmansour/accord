#!/bin/bash
# This script refreshes the /usr/local/accord directory structure
# with the latest contents on artifactory

pushd /tmp
rm -f accord-linux.tar.gz
getfile.sh ext-tools/utils/accord-linux.tar.gz
cd /usr/local
tar xvzf /tmp/accord-linux.tar.gz

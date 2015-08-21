#!/bin/bash
# Install the accord directory on linux

rm -f accord-linux.tar.gz
getfile.sh ext-tools/utils/accord-linux.tar.gz
pushd /usr/local
    tar xvzf ~/accord-linux.tar.gz
popd

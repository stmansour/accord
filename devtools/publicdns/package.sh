#!/bin/bash
pushd /usr/local
tar cvf accord-linux.tar accord
gzip accord-linux.tar
popd
mv /usr/local/accord-linux.tar.gz .
echo "accord-linux.tar.gz ready for publishing"

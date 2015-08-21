#!/bin/bash

#  $1 = artifactory path
#  $2 = filename
#
artf_update () {
    if [ ! -f $2 ]; then
	echo "File $2 does not exist"
	exit 1
    else
	echo "removing $1/$2"
	rmfile.sh "$1/$2"
	echo "adding $2 to $1"
	deployfile.sh $2 $1
    fi
}

if [ ! -f accord-linux.tar.gz ]; then
    ./package.sh
fi

artf_update ext-tools/utils accord-linux.tar.gz.tar

echo "*** COMPLETED ***"

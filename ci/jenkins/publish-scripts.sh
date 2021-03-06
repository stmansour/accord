#!/bin/bash

#
#  $1 = artifactory path
#  $2 = filename
#
artf_update () {
    if [ ! -f "$2" ]; then
	echo "File $2 does not exist"
	exit 1
    else
	echo "removing $1/$2"
	rmfile.sh "$1/$2"
	echo "adding $2 to $1"
	deployfile.sh "$2" "$1"
    fi
}

artf_update ext-tools/utils getcygwin.bat
# artf_update ext-tools/utils setup-win-jenkins.bat
# artf_update ext-tools/utils setup-linux-jenkins.sh
# artf_update ext-tools/utils ottoaccord.tar.gz
# artf_update ext-tools/utils winjenk.scr

if [ ! -d ./tmp ]; then
    mkdir ./tmp
fi
cd ./tmp
cp ../ottoaccord.tar.gz .
gunzip ottoaccord.tar.gz
artf_update ext-tools/utils ottoaccord.tar
rm ottoaccord.tar
cd ..

echo "*** COMPLETED ***"

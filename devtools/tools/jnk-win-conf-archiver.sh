#!/bin/bash

ACCORD_BIN=/cygdrive/c/accord/bin
JENKINS_HOME="/cygdrive/c/Program\ Files\ \(x86\)/Jenkins/"
ARTIFACT=jnk-win-conf.tar

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
        ${ACCORD_BIN}/rmfile.sh "$1/$2"
        echo "adding $2 to $1"
        ${ACCORD_BIN}/deployfile.sh "$2" "$1"
    fi
}

cd "${JENKINS_HOME}"
tar cvf ${ARTIFACT} ./*.xml plugins users
artf_update ext-tools/jenkins ${ARTIFACT}
echo "*** COMPLETED ***"
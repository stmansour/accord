#!/bin/bash
# This is a simple script to do a trivial backup of
# all jenkins jobs. It does NOT save history or any of the 
# information about builds. It simply saves the config
# file and the nextBuildNumber.  The restore script adds
# the skeletal directory structure jenkins needs.
#
# sman
# Ver 1.0

ACCORD_BIN=/usr/local/accord/bin
ARTIFACT=jnk-lnx-jobs.tar

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

if [ ! -z "$JENKINS_HOME" ]; then
    cd "$JENKINS_HOME"/jobs
fi
pwd
tar cvf ${ARTIFACT} ./*/config.xml ./*/nextBuildNumber
echo "Storing ${ARTIFACT} to Artifactory:/ext-tools/jenkins"
artf_update ext-tools/jenkins ${ARTIFACT}

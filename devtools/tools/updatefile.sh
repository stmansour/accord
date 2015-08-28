#!/bin/bash
#
# sman
# Ver 1.0

usage() {
    echo
    echo "Purpose: Download a file from artifactory to the local system"
    echo "Usage:   $0 remotePath localfile"
    echo "Example: $0 ext-tools/utils deployfile.sh"
    echo
    exit 1
}

if [ -z "$1" ]; then
    usage
    exit 1
fi

#
#  $1 = artifactory path
#  $2 = filename
#
ACCORD_BIN=/usr/local/accord/bin
if [ ! -f "$2" ]; then
    echo "File $2 does not exist"
    exit 1
else
    echo "removing $1/$2"
    ${ACCORD_BIN}/rmfile.sh "$1/$2"
    echo "adding $2 to $1"
    ${ACCORD_BIN}/deployfile.sh "$2" "$1"
fi  

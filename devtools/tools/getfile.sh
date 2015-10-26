#!/bin/bash

usage() {
	echo
    echo "Purpose: Download a file from artifactory to the local system"
    echo "Usage:   $0 remotefilepath"
    echo "Example: $0  ext-tools/utils/s.bat"
    echo
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

APATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
ARTIF=${APATH}/artifactory.url
ARTPSW=${APATH}/credp
targetPath=$(cat ${ARTIF})
artp=$(cat ${ARTPSW})
artu="accord"

echo "reading from ${targetPath}"
remoteFile="$1"

echo "wget --user=${artu} --password=${artp} ${targetPath}/${remoteFile}"
wget --user=${artu} --password=$artp ${targetPath}/"${remoteFile}"

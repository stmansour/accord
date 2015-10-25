#!/bin/bash

usage() {
	echo
    echo "Purpose: Remove the supplied file from artifactory"
    echo "Usage:   $0 targetPath/file"
    echo "example: $0 ext-tools/utils/setup-win-jenkins"
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
artu="accord"
artp=$(cat ${ARTPSW})
target="$1"

echo "INFO: Deleting ${targetPath}/${target}"
curl -i -X DELETE -u ${artu}:${artp} "${targetPath}/${target}"

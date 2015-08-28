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

targetPath="http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory"

echo "reading from $targetPath"
remoteFile="$1"
artifactoryUser="accord"
artifactoryPassword="AP4GxDHU2f6EriLqry781wG6fy"

echo "wget --user=$artifactoryUser --password=$artifactoryPassword $targetPath/$remoteFile"
wget --user=$artifactoryUser --password=$artifactoryPassword $targetPath/"$remoteFile"

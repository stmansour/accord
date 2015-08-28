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

artAddr="http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory"
target="$1"
artifactoryUser="user"
artifactoryPassword="AP6k6bTdGdXg3Njs"

echo "INFO: Deleting $artAddr/$target"
curl -i -X DELETE -u $artifactoryUser:$artifactoryPassword "$artAddr/$target"

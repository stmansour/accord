#!/bin/bash

usage() {
    echo "remove the supplied filename from artifactory"
    echo "Usage: $0 target/file"
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

MD5="md5sum"

if [ `uname` = "Darwin" ]; then
    MD5="md5 -r"
fi

target="$1"
artifactoryUser="user"
artifactoryPassword="Dai5F0p"

echo "INFO: Deleting $target"
curl -i -X DELETE -u $artifactoryUser:$artifactoryPassword $target

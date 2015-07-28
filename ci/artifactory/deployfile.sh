#!/bin/bash

usage() {
    echo "Deploy a local file to Artifactory keeping the same file name"
    echo "Usage: $0 localFilePath targetFolder"
    echo "./deployfile.sh setup http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/jenkins-snapshot"
    exit 1
}

if [ -z "$2" ]; then
    usage
fi

MD5 = "md5sum";
if [ `uname` = "Darwin" ]; then
    $MD5 = "md5 -r"
fi

localFilePath="$1"
targetFolder="$2"
artifactoryUser="user"
artifactoryPassword="Dai5F0p"

if [ ! -f "$localFilePath" ]; then
    echo "ERROR: local file $localFilePath does not exists!"
    exit 1
fi

which md5sum || exit $?
which sha1sum || exit $?

md5Value="`$MD5 "$localFilePath"`"
md5Value="${md5Value:0:32}"
sha1Value="`$ "$localFilePath"`"
sha1Value="${sha1Value:0:40}"
fileName="`basename "$localFilePath"`"

echo $md5Value $sha1Value $localFilePath

echo "INFO: Uploading $localFilePath to $targetFolder/$fileName"
curl -i -X PUT -u $artifactoryUser:$artifactoryPassword \
 -H "X-Checksum-Md5: $md5Value" \
 -H "X-Checksum-Sha1: $sha1Value" \
 -T "$localFilePath" \
 "$targetFolder/$fileName"


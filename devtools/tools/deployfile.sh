#!/bin/bash

usage() {
    echo
    echo "Purpose: Deploy a local file to Artifactory keeping the same file name."
    echo "Usage:   $0 localFilePath targetFolder"
    echo "Example: $0 ottoaccord.tar.gz ext-tools/utils"
    echo
    exit 1
}

if [ -z "$2" ]; then
    usage
fi

targetPath="http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory"

echo "deploying to $targetPath"
localFilePath="$1"
targetFolder="$2"
artifactoryUser="user"
artifactoryPassword="AP6k6bTdGdXg3Njs"

if [ ! -f "$localFilePath" ]; then
    echo "ERROR: local file $localFilePath does not exists!"
    exit 1
fi

if [ "$(uname)" = "Darwin" ]; then
    MD5="md5 -r"
    md5Value="$($MD5 "$localFilePath")"
    md5Value="${md5Value:0:32}"
    echo "MD5 = $md5Value $localFilePath"
else
    MD5="md5sum"
    which $MD5 || exit $?
    md5Value="$($MD5 "$OPTS" "$localFilePath")"
    md5Value="${md5Value:0:32}"
    which sha1sum || exit $?
    sha1Value="$(sha1sum "$localFilePath")"
    sha1Value="${sha1Value:0:40}"
    echo "MD5 and SHA1 = $md5Value $sha1Value $localFilePath"
fi

fileName="$(basename "$localFilePath")"

echo "INFO: Uploading $localFilePath to $targetPath/targetFolder/$fileName"
if [ "$(uname)" = "Darwin" ]; then
    echo "curl -i -X PUT -u $artifactoryUser:$artifactoryPassword -H \"X-Checksum-Md5: $md5Value\" -T \"$localFilePath\" \"$targetPath/$targetFolder/$fileName\""
    curl -i -X PUT -u $artifactoryUser:$artifactoryPassword -H "X-Checksum-Md5: $md5Value" -T "$localFilePath" "$targetPath/$targetFolder/$fileName"
else
    curl -i -X PUT -u $artifactoryUser:$artifactoryPassword -H "X-Checksum-Md5: $md5Value" -H "X-Checksum-Sha1: $sha1Value" -T "$localFilePath"  "$targetPath/$targetFolder/$fileName"
fi

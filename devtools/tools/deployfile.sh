#!/bin/bash

usage() {
    echo
    echo "Purpose: Deploy a local file to Artifactory keeping the same file name."
    echo "Usage:   $0 localFname targetFolder"
    echo "Example: $0 ottoaccord.tar.gz ext-tools/utils"
    echo
    exit 1
}

if [ -z "$2" ]; then
    usage
fi

targetPath="http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory"

echo "deploying to $targetPath"
localFname="$1"
targetFolder="$2"
artu="user"
artp="AP6k6bTdGdXg3Njs"

if [ ! -f "$localFname" ]; then
    echo "ERROR: local file $localFname does not exists!"
    exit 1
fi

sysname=$(uname)

case "${sysname}" in
    "Darwin" )
	MD5="md5 -r"
	md5Value="$($MD5 "$localFname")"
	md5Value="${md5Value:0:32}"
	echo "MD5 = $md5Value $localFname"
	;;

    "MINGW32_NT-6.2" | "CYGWIN_NT-6.2" )
	echo "will attempt to md5sum $localFname"
	MD5="md5sum"
	which $MD5 || exit $?
	md5Value="$($MD5 "$localFname")"
	md5Value="${md5Value:0:32}"
	;;

    * )
	echo "will attempt to md5sum $localFname"
	MD5="md5sum"
	which $MD5 || exit $?
	md5Value="$($MD5 "$localFname")"
	md5Value="${md5Value:0:32}"
	which sha1sum || exit $?
	sha1Value="$(sha1sum "$localFname")"
	sha1Value="${sha1Value:0:40}"
	echo "MD5 and SHA1 = $md5Value $sha1Value $localFname"
	;;
esac

fname="$(basename "$localFname")"

echo "INFO: Uploading $localFname to $targetPath/$targetFolder/$fname"
case "${sysname}" in
    "Darwin" | "MINGW32_NT-6.2" | "CYGWIN_NT_6.2" )
	echo "curl for ${sysname}"
	curl -i -X PUT -u $artu:$artp -H "X-Checksum-Md5: $md5Value" -T "$localFname" "$targetPath/$targetFolder/$fname"
	;;

    * )
	echo "curl for ${sysname}"
	curl -i -X PUT -u $artu:$artp -H "X-Checksum-Md5: $md5Value" -H "X-Checksum-Sha1: $sha1Value" -T "$localFname"  "$targetPath/$targetFolder/$fname"
	;;
esac

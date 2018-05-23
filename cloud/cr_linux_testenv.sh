#!/bin/bash
#  This script creates a new Linux test environment based on the supplied user-data file.

# Parameters:
#  $1 = name of the startup script
#  $2 = absolute directory that should be the current directory for launching this script.
#       This is an optional parameter. But the script will exit if the startup script is not
#       found in the current directory.

DRYRUN=0
AMI="ami-14c5486b"
INSTANCESIZE="t2.micro"
#INSTANCESIZE="t2.medium"
KEYNAME="smanAWS1"


if [ "x" == "x$1" ]; then
	echo "*** ERROR ***  You must supply the launch startup script"
	exit 1
fi

DIR=$(pwd)
if [ "x" != "x$2" ]; then
	DIR="$2"
fi

if [ ! -f "$DIR/$1" ]; then
	echo "*** ERROR ***  File does not exist in this directory:  $1"
	exit 2
fi

if [ "x" != "x$3" ]; then
	if [ "-n" == "$3" ]; then
		DRYRUN=1
	fi
fi

echo "cd ${DIR};aws ec2 run-instances --output json --image-id ${AMI} --count 1 --instance-type ${INSTANCESIZE} --key-name smanAWS1  --security-groups Linux-Jenkins-CI  --user-data file://$1 >> $1.json"
if [ ${DRYRUN} -eq 0 ]; then
	cd ${DIR};aws ec2 run-instances --output json --image-id ${AMI} --count 1 --instance-type ${INSTANCESIZE} --key-name smanAWS1  --security-groups Linux-Jenkins-CI  --user-data file://$1 >> $1.json
fi
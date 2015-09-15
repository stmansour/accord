#!/bin/bash
#  This script creates a new Linux test environment based on the supplied user-data file.

if [ "x" = "x$1" ]; then
	echo "*** ERROR ***  You must supply the launch startup script"
	exit 1
fi

if [ ! -f "$1" ]; then
	echo "*** ERROR ***  File does not exist in this directory:  $1"
	exit 2
fi

echo "aws ec2 run-instances --output json --image-id ami-1ecae776 --count 1 --instance-type t2.micro --key-name smanAWS1  --security-groups Linux-Jenkins-CI  --user-data file://$1 >> $1.json"
# aws ec2 run-instances --output json --image-id ami-1ecae776 --count 1 --instance-type t2.micro --key-name smanAWS1  --security-groups Linux-Jenkins-CI  --user-data file://$1 >> $1.json

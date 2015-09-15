#!/bin/bash
#  This script creates a new Windows test environment based on the supplied user-data file.

if [ "x" = "x$1" ]; then
	echo "*** ERROR ***  You must supply the launch startup script"
	exit 1
fi

if [ ! -f "$1" ]; then
	echo "*** ERROR ***  File does not exist in this directory:  $1"
	exit 2
fi

echo "aws ec2 run-instances --output json --image-id ami-6f2cf804 --count 1 --instance-type t2.micro --key-name smanAWS1  --security-groups Windows-Jenkins --user-data file://$1 >> $1.json"
# aws ec2 run-instances --output json --image-id ami-417bcf2a --count 1 --instance-type t2.micro --key-name smanAWS1  --security-groups Windows-Jenkins --user-data file://$1 >> $1.json

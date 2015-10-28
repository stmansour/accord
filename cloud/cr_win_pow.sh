#!/bin/bash
#  Create POW = Plain Ol' Windows

MAXINSTANCES=20
instances=1
ask=1
AMI="ami-c9cea0ac"
if [ $# -gt 0 ]; then 
    while [ $ask -gt 0 ]; do
	echo -n "Create $1 instances, are you sure? [y/n]: "
	read ans
	case $ans in
	    [yY] | [yY][Ee][Ss] )
		instances=$1
		ask=0
		if [ $instances -gt $MAXINSTANCES ]; then
		    echo "My max limit is $MAXINSTANCES. I'll set it to $MAXINSTANCES instances."
		    instances=$MAXINSTANCES
		fi
		;;
	    [nN] | [n|N][O|o] )
		exit 1
		;;
	    *)
		echo "Just enter yes or no or Y or n or something..."
		;;
	esac
    done
fi
pushd /usr/local/accord/bin
echo "Creating ${instances} instances..."
aws ec2 run-instances --output json --image-id ${AMI} --count ${instances} --instance-type t2.micro --key-name smanAWS1  --security-groups my-security-group --user-data file://pow.scr > new-windows-pow-instance.json
popd
date

#!/bin/bash
instances=1
ask=1
if [ $# -gt 0 ]; then 
    while [ $ask -gt 0 ]; do
	echo -n "Create $1 instances, are you sure? [y/n]: "
	read ans
	case $ans in
	    [yY] | [yY][Ee][Ss] )
		instances=$1
		ask=0
		if [ $instances -gt 10 ]; then
		    echo "My max limit is 10. I'll set it to 10 instances."
		    instances=10
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
aws ec2 run-instances --output json --image-id ami-6f2cf804 --count ${instances} --instance-type t2.micro --key-name smanAWS1  --security-groups Windows-Jenkins --user-data file://winjenk.scr > new-windows-jenkins-instance.json
popd
date

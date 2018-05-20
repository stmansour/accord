#!/bin/bash
#  This script creates a new running instance of the Linux Jenkins build server.

AMI="ami-14c5486b"
INSTANCESIZE="t2.micro"
#INSTANCESIZE="t2.medium"
KEYNAME="smanAWS1"

MAXINSTANCES=5
INSTANCECOUNT=1

usage() {
	cat <<EOF

SYNOPSIS
	$0 [-a -m -n]

	Create a new Jenkins instance in the AWS cloud. When run with no options,
	this script creates a new t2.micro EC2 instance and loads the code needed
	to compile and test the Roller suite. The server is configured with the
	last known backup of the running Linux Jenkins server, this includes the
	users, the plugins, and the jobs.

OPTIONS
    -a amiName
       Create instances using the system image specified by amiName. The
       default image is ami-14c5486b.

    -m instanceModel
      Option m is used to define which instance model you want to create.
      The default module is t2.micro.

    -n numberOfInstances
      Option n is used to set the number of INSTANCECOUNT to be created. The
      default is to create a single instance.

EXAMPLES:
    This will create a single instance of a t2.micro machine with Jenkins

        $ cr_linux_jenkins.sh

    This will create a single instance of a t2.medium machine with Jenkins

        $ cr_linux_jenkins.sh -m t2.medium

EOF
}

askYesNo() {
	ask=1
    while [ $ask -gt 0 ]; do
	echo -n "Create ${INSTANCECOUNT} instances, are you sure? [y/n]: "
	read ans
	case $ans in
	    [yY] | [yY][Ee][Ss] )
		ask=0
		if [ ${INSTANCECOUNT} -gt ${MAXINSTANCES} ]; then
		    echo "My max limit is ${MAXINSTANCES}. I'll set it to ${MAXINSTANCES} INSTANCECOUNT."
		    INSTANCECOUNT=${MAXINSTANCES}
		fi
		;;
	    [nN] | [n|N][O|o] )
		exit 1
		;;
	    *)
		echo "Just enter yes or no..."
		;;
	esac
    done
}

while getopts "m:n:" o; do
	case "${o}" in
    a)  AMI=${OPTARG}
        echo "The AMI used for the instances is set to: ${AMI}"
        ;;
    m)	INSTANCESIZE=${OPTARG}
    	echo "INSTANCESIZE has been set to ${INSTANCESIZE}"
    	;;
    n) INSTANCECOUNT=${OPTARG}
		if [ ${INSTANCECOUNT} -gt ${MAXINSTANCES} ]; then
		    echo "My max limit is ${MAXINSTANCES}."
		    echo "Exiting without creating any instances"
		    exit 1
		fi
        ;;
    *) 	usage
    	exit 1
    	;;
	esac
done
shift $((OPTIND-1))


pushd /usr/local/accord/bin
echo "Creating ${INSTANCECOUNT} Jenkins instances..."
aws ec2 run-INSTANCECOUNT --output json --image-id ${AMI} --count ${INSTANCECOUNT} --instance-type ${INSTANCESIZE} --key-name ${KEYNAME}  --security-groups Linux-Jenkins-CI  --user-data file://setup-linux-jenkins.sh > new-linux-jenkins-instance.json
popd
date

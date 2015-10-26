#!/bin/bash
#
# qmaster for linux
# This script is designed prepare a new linux instance to run an
# application and potentially a test. Uhura is the coordinator and 
# handles communication between the apps and the master, which runs
# on the build machine.
#
# The logfile produced by Amazon for this script is in:
# /var/log/cloud-init-output.log
#
ACCORDHOME=/usr/local/accord
LOGFILE=qmaster.log
cd ~ec2-user/
echo "qmaster log" >>${LOGFILE} 2>&1
date >> ${LOGFILE}

#--------------------------------------------------------------
#  Our credentials to work with Artifactory
#--------------------------------------------------------------
USR=accord
PASS=AP3wHZhcQQCvkC4GVCCZzPcqe3L
ART=http://ec2-52-91-201-195.compute-1.amazonaws.com/artifactory

EXTERNAL_HOST_NAME=$( curl http://169.254.169.254/latest/meta-data/public-hostname )
${EXTERNAL_HOST_NAME:?"Need to set EXTERNAL_HOST_NAME non-empty"}

#--------------------------------------------------------------
#  Routine to download files from Artifactory
#--------------------------------------------------------------
artf_get() {
    echo "Downloading $1/$2"
    wget -O "$2" --user=$USR --password=$PASS ${ART}/"$1"/"$2"
}

#--------------------------------------------------------------
#  function to install mysql
#--------------------------------------------------------------
install_mysql() {
	echo "installing mysql"
	yum -y install mysql55-server.x86_64
	service mysqld start
	echo "CREATE DATABASE accord;use accord;GRANT ALL PRIVILEGES ON Accord TO 'ec2-user'@'localhost';"  | mysql
}

restoredb() {
	echo "IN RESTOREDB"
	pushd /tmp
	DIR=$(pwd)
	echo "CURRENT DIRECTORY = ${DIR}"
	echo "${ACCORDHOME}/bin/getfile.sh getfile.sh ext-tools/testing/$1"
	${ACCORDHOME}/bin/getfile.sh getfile.sh ext-tools/testing/$1
	echo "Get file $1 completed"
	echo "${ACCORDHOME}/testtools/restoredb.sh /tmp/$1"
	${ACCORDHOME}/testtools/restoredb.sh /tmp/$1
	echo "restoredb.sh completed"
	popd
	DIR=$(pwd)	
	echo "popd completed, dir = ${DIR}"
}
#--------------------------------------------------------------
#  update all the out-of-date packages, add Java 1.8, and md5sum
#--------------------------------------------------------------
yum -y update
yum -y install java-1.8.0-openjdk-devel.x86_64
yum -y install isomd5sum.x86_64

#--------------------------------------------------------------
#  Let's get our tools in place...
#--------------------------------------------------------------
artf_get ext-tools/utils accord-linux.tar.gz
echo "Installing /usr/local/accord" >>${LOGFILE}
cd /usr/local
tar xvzf ~ec2-user/accord-linux.tar.gz
chown -R ec2-user:ec2-user accord
cd ~ec2-user/

#----------------------------------------------
#  Now download the requested apps...
#----------------------------------------------
# - - - - -  APPEND DATA and DOWNLOAD APPS  - - - - - - -

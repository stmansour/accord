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

LOGFILE=qmaster.log
cd ~
echo "qmaster log" >>${LOGFILE} 2>&1
date >> ${LOGFILE}

#--------------------------------------------------------------
#  Our credentials to work with Artifactory
#--------------------------------------------------------------
USR=accord
PASS=AP4GxDHU2f6EriLqry781wG6fy
ART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory

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
tar xvzf ~/accord-linux.tar.gz
cd ~

#----------------------------------------------
#  Now download the requested apps...
#----------------------------------------------
# - - - - -  APPEND DATA and DOWNLOAD APPS  - - - - - - -

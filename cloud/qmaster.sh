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
echo -n "User: " >> ${LOGFILE}
$(whoami) >> ${LOGFILE}

#--------------------------------------------------------------
#  Our credentials to work with Artifactory
#--------------------------------------------------------------
USR=accord
PASS=AP3wHZhcQQCvkC4GVCCZzPcqe3L
ART=http://ec2-54-227-227-112.compute-1.amazonaws.com/artifactory

EXTERNAL_HOST_NAME=$( curl http://169.254.169.254/latest/meta-data/public-hostname )
${EXTERNAL_HOST_NAME:?"Need to set EXTERNAL_HOST_NAME non-empty"}

#--------------------------------------------------------------
#  Routine to download files from Artifactory
#--------------------------------------------------------------
artf_get() {
    echo "Downloading $1/$2"
    wget -q -O "$2" --user=${USR} --password=${PASS} ${ART}/"$1"/"$2"
}

#--------------------------------------------------------------
#  function to install mysql
#--------------------------------------------------------------
install_mysql_old() {
	echo "installing mysql"
	yum -y install mysql55-server.x86_64
	service mysqld start
	echo "CREATE DATABASE accord;use accord;GRANT ALL PRIVILEGES ON accord.* TO 'ec2-user'@'localhost';"  | mysql

	# 09-Feb-2016 - ensure that mysql comes back up on reboot...
	chkconfig mysqld on
}

#---------------------------------------------------------------------------------------------
# This script will download mysql version as specified in `MYSQL_RELEASE`
# Origin of this script: https://gist.github.com/rsudip90/99c0bb04d6e2157b4cc12aea5ed0eb36
# Refer to origin for comments.  Unnecessary lines have been removed, including comments.
# Guidance: https://dev.mysql.com/doc/refman/5.7/en/linux-installation-yum-repo.html
#---------------------------------------------------------------------------------------------
install_mysql() {
	MYSQL_RELEASE=mysql57-community-release-el6-11.noarch.rpm
	MYSQL_RELEASE_URL="https://dev.mysql.com/get/${MYSQL_RELEASE}"
	MYSQL_SERVICE=mysqld
	MYSQL_LOG_FILE=/var/log/${MYSQL_SERVICE}.log
	exitError() {
	    echo "Error: $1" >&2
	    exit 1
	}
	echo "Downloading mysql release package from specified url: $MYSQL_RELEASE_URL..."
	wget -O $MYSQL_RELEASE $MYSQL_RELEASE_URL || exitError "Could not fetch required release of mysql: ($MYSQL_RELEASE_URL)"
	echo "Adding mysql yum repo in the system repo list..."
	yum localinstall -y $MYSQL_RELEASE || exitError "Unable to install mysql release ($MYSQL_RELEASE) locally with yum"
	echo "Checking that mysql yum repo has been added successfully..."
	yum repolist enabled | grep "mysql.*-community.*" || exitError "Mysql release package ($MYSQL_RELEASE) has not been added in repolist"
	echo "Checking that at least one subrepository is enabled for one release..."
	yum repolist enabled | grep mysql || exitError "At least one subrepository should be enabled for one release series at any time."
	echo "Installing mysql-community-server..."
	yum install -y mysql-community-server || exitError "Unable to install mysql mysql-community-server"
	if cat /etc/my.cnf | grep "sql-mode"; then
	    echo "sql-mode already has been set !!!"
	else
	    echo "Setting up sql-mode in /etc/my.cnf..."
	    echo 'sql-mode="ALLOW_INVALID_DATES"' >> /etc/my.cnf || exitError "Unable to set sql-mode in /etc/my.cnf file"
	    echo "sql-mode has been set to ALLOW_INVALID_DATES in /etc/my.cnf"
	fi
	echo "Starting mysql service..."
	service $MYSQL_SERVICE start || exitError "Could not start mysql service"
	echo "Checking status of mysql service..."
	service $MYSQL_SERVICE status || exitError "Mysql service is not running"
	echo "Setting up mysql as in startup service..."
	chkconfig mysqld on
	echo "extracting password from log file: ${MYSQL_LOG_FILE}..."
	MYSQL_PWD=$(grep -oP '(?<=A temporary password is generated for root@localhost: )[^ ]+' ${MYSQL_LOG_FILE})
	echo "Auto generated password is: ${MYSQL_PWD}" > /home/ec2-user/mysql_pass.txt
	# install expect program to interact with mysql program
	yum install -y expect

	MYSQL_UPDATE=$(expect -c "

	set timeout 5
	spawn mysql -u root -p

	expect \"Enter password: \"
	send \"${MYSQL_PWD}\r\"

	expect \"mysql>\"
	send \"ALTER USER 'root'@'localhost' IDENTIFIED BY 'Admin1234!';\r\"

	expect \"mysql>\"
	send \"uninstall plugin validate_password;\r\"

	expect \"mysql>\"
	send \"ALTER USER 'root'@'localhost' IDENTIFIED BY '';\r\"

	expect \"mysql>\"
	send \"CREATE USER 'ec2-user'@'localhost';\r\"

	expect \"mysql>\"
	send \"CREATE DATABASE accord; use accord; GRANT ALL PRIVILEGES ON accord.* TO 'ec2-user'@'localhost';\r\"

	expect \"mysql>\"
	send \"quit;\r\"

	expect eof
	")

	echo "$MYSQL_UPDATE"
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

initBashProfile() {
    chmod 0666 ~ec2-user/.bash_profile
    cat >> ~ec2-user/.bash_profile <<EOF
export ACCORD=/usr/local/accord
export PATH=\${PATH}:\${ACCORD}/bin:\${ACCORD}/testtools:/usr/local/bin
alias ll='ls -al'
alias la='ls -a'
alias ls='ls -FCH'
alias ff='find . -name'
alias goa='cd ~/apps/accord'
alias gom='cd ~/apps/mojo'
alias goms='cd ~/apps/mojo/mojosrv'
alias gor='cd ~/apps/rentroll'
alias got='cd ~/apps/tgo'
alias gop='cd ~/apps/phonebook'
EOF
    chmod 0644 ~ec2-user/.bash_profile

}
# install jfrog
installJFrog() {
	# Download jfrog cli from the repo.
	USER=$(grep user ~ec2-user/.jfrog/jfrog-cli.conf | awk '{print $2;}' | sed 's/\"//g' | sed 's/,//')
	PSWD=$(grep password ~ec2-user/.jfrog/jfrog-cli.conf | awk '{print $2;}' | sed 's/\"//g' | sed 's/,//')
	ARTF=$(grep url ~ec2-user/.jfrog/jfrog-cli.conf | awk '{print $2;}' | sed 's/\"//g' | sed 's/,//')
    echo "In instalJfrog()  USER=${USER}, PSWD=${PSWD}, ARTF=${ARTF}"
    echo -n "Current directory = "
    pwd
    echo "will execute: curl -u ${USER}:${PSWD} ${ARTF}accord/tools/jfrog > jfrog"
    curl -s -u ${USER}:${PSWD} ${ARTF}accord/tools/jfrog > jfrog
    if [ ! -d /usr/local/bin ]; then
        mkdir -p /usr/local/bin
    fi
    mv jfrog /usr/local/bin
}

#--------------------------------------------------------------
#  Let's get our tools in place...
#--------------------------------------------------------------
artf_get ext-tools/utils accord-linux.tar.gz
echo "Installing /usr/local/accord" >>${LOGFILE}
cd /usr/local
tar xvzf ~ec2-user/accord-linux.tar.gz
chown -R ec2-user:ec2-user accord
cd ~ec2-user/
tar xvf /usr/local/accord/bin/jfrog.tar
chown -R ec2-user:ec2-user .jfrog
installJFrog
initBashProfile

#--------------------------------------------------------------
#  update all the out-of-date packages, add Java 1.8, and md5sum
#--------------------------------------------------------------
yum -y update
yum -y install java-1.8.0-openjdk-devel.x86_64
yum -y install isomd5sum.x86_64


#----------------------------------------------
#  Now download the requested apps...
#----------------------------------------------
# - - - - -  APPEND DATA and DOWNLOAD APPS  - - - - - - -

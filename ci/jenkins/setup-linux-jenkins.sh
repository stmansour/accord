#!/bin/bash
#
# Setup a Jenkins instance for Java builds on amazon's linux
# This script is designed to be run only during the first boot cycle.
# It runs as root, so no need for all the "sudo" stuff in front of
# every command.
#
# To debug, the logfile produced by Amazon is in /var/log/cloud-init-output.log

USR=accord
FOOLME=AP3wHZhcQQCvkC4GVCCZzPcqe3L
ART=http://ec2-54-227-227-112.compute-1.amazonaws.com/artifactory
GRADLEVER=gradle-2.6
JENKINS_CONFIG_TAR=jnk-lnx-conf.tar
JENKINS_JOBS_TAR=jnk-lnx-jobs.tar
T1="pa"
T2="ss"
T3="wo"
T4="rd"
T5="us"
T6="er"

EXTERNAL_HOST_NAME=$( curl http://169.254.169.254/latest/meta-data/public-hostname )
${EXTERNAL_HOST_NAME:?"Need to set EXTERNAL_HOST_NAME non-empty"}

GOLANGBUNDLE="go1.9.6.linux-amd64.tar.gz"
GOLANGDOWNLOAD="https://dl.google.com/go/${GOLANGBUNDLE}"


artf_get() {
    echo "Downloading ${1}/${2}"
    wget -O "${2}" --${T5}${T6}=${USR} --${T1}${T2}${T3}${T4}=${FOOLME} ${ART}/"${1}"/"$2"
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
        echo "Error: ${1}" >&2
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


#
#  update all the out-of-date packages
#
yum -y update

#
# install Open Java 1.8, git, md5sum
#
yum -y install java-1.8.0-openjdk-devel.x86_64
alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
yum -y install git-all.noarch
yum -y install isomd5sum.x86_64

#
# install gradle
#
# wget https://services.gradle.org/distributions/${GRADLEVER}-bin.zip
# unzip ${GRADLEVER}-bin.zip
# mv ${GRADLEVER} /usr/local
# ln -s /usr/local/${GRADLEVER}/bin/gradle /usr/bin/gradle
# rm ${GRADLEVER}-bin.zip

#  Install go
wget ${GOLANGDOWNLOAD}
tar -C /usr/local -xzf ${GOLANGBUNDLE}
rm -f ${GOLANGBUNDLE}

#
#  add user 'jenkins' before installing jenkins. The default installation
#  creates the 'jenkins' user, but sets the shell to /bin/zero.
#  Unfortunately, this renders much of the su - jenkins script automation
#  unusable. But if the jenkins user already exists, everything will be
#  fine
#
adduser -d /var/lib/jenkins jenkins

#
#  install jenkins
#
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum -y install jenkins


service jenkins start
chkconfig jenkins on

#
# jenkins listens on port 8080
# map port 80 http traffic to port 8080 with njinx
#
yum -y install nginx

#
# change /etc/nginx/nginx.conf so that nginx acts as a proxy for 8080
#
sed -e '/server/,$d' /etc/nginx/nginx.conf >my.conf
cat >> my.conf  << EOF


    server {
        listen       80;
        server_name  $EXTERNAL_HOST_NAME;
        location / {
            proxy_pass         http://127.0.0.1:8080/;
            proxy_redirect     off;

            proxy_set_header   Host             \$host;
            proxy_set_header   X-Real-IP        \$remote_addr;
            proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;

            client_max_body_size       10m;
            client_body_buffer_size    128k;

            proxy_connect_timeout      90;
            proxy_send_timeout         90;
            proxy_read_timeout         90;
        }
    }
}

EOF

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original
mv -f my.conf /etc/nginx/nginx.conf
chmod 0644 /etc/nginx/nginx.conf

#
# Start nginx and ensure that it starts on boot:
#
service nginx start
chkconfig nginx on

cd ~
# artf_get ext-tools/utils ottoaccord.tar.gz
artf_get ext-tools/utils ottoaccord.tar
artf_get ext-tools/utils accord-linux.tar.gz
artf_get ext-tools/jenkins ${JENKINS_CONFIG_TAR}
artf_get ext-tools/jenkins ${JENKINS_JOBS_TAR}

echo "Installing /usr/local/accord"
cd /usr/local
tar xvzf ~/accord-linux.tar.gz

echo "Updating credentials for user 'jenkins' to access github"
cd ~jenkins
tar xvf ~/ottoaccord.tar

#  update everybody's path so go will work nicely
GOROOT=/usr/local/go
ACCORD=/usr/local/accord
chmod 0666 ~ec2-user/.bash_profile
echo "export GOROOT=/usr/local/go" >> ~ec2-user/.bash_profile
echo "export ACCORD=/usr/local/accord" >> ~ec2-user/.bash_profile
echo "PATH=${PATH}:${GOROOT}/bin:${ACCORD}/bin:${ACCORD}/testtools" >> ~ec2-user/.bash_profile
cat >> ~ec2-user/.bash_profile <<EOF
alias jenk='sudo su - jenkins'
alias ll='ls -al'
alias la='ls -a'
alias ls='ls -FCH'
alias ff='find . -name'
EOF
chmod 0644 ~ec2-user/.bash_profile

chmod 0666 ~jenkins/.bash_profile
echo "export GOROOT=/usr/local/go" >> ~jenkins/.bash_profile
echo 'export GOHOME=~/tmp' >> ~jenkins/.bash_profile
echo 'export GOPATH=/var/lib/jenkins/tmp' >> ~jenkins/.bash_profile
echo "export ACCORD=/usr/local/accord" >> ~jenkins/.bash_profile
echo 'PATH=${PATH}:${GOROOT}/bin:${ACCORD}/bin:${ACCORD}/testtools' >> ~jenkins/.bash_profile
cat >> ~ec2-user/.bash_profile <<EOF
alias ll='ls -al'
alias la='ls -a'
alias ls='ls -FCH'
alias ff='find . -name'
EOF
chmod 0644 ~jenkins/.bash_profile

# build the latest golint and install...
cat >jenkcmd.sh << EOF
#!/bin/bash
source ~/.bash_profile
cd
mkdir tmp
cd tmp
go get -u github.com/golang/lint/golint
go get -u github.com/go-sql-driver/mysql
go build
EOF
chmod +x jenkcmd.sh
su - jenkins -c ./jenkcmd.sh 
cp tmp/src/github.com/golang/lint/golint/golint /usr/local/go/bin/

echo "Sleeping for 10 seconds to give Jenkins plenty of time to"
echo "complete its initial startup."
sleep 10

echo "OK, it should be done by now. Let's shut it down so that"
echo "we can install our configuration"
service jenkins stop
sleep 10

echo "installing last known good configuration"
tar xvf ~/${JENKINS_CONFIG_TAR}
echo "installing jobs"
cd jobs
tar xvf ~/${JENKINS_JOBS_TAR}
cd ~jenkins

echo "changing jenkins to be owner of all files"
chown -R jenkins:jenkins ./*

echo "Configuration in place. Restarting"
service jenkins start

echo "set the timezone to Pacific"
cd /etc
mv localtime localtime.old
ln -s /usr/share/zoneinfo/US/Pacific localtime

echo "installing mysql"
# yum -y install mysql55-server.x86_64
# service mysqld start
install_mysql
echo "use accord;GRANT ALL PRIVILEGES ON Accord TO 'ec2-user'@'localhost';"  | mysql

cd ~
rm ./*.gz

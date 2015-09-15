#!/bin/bash
#
# Setup a Jenkins instance for Java builds on amazon's linux
# This script is designed to be run only during the first boot cycle.
# It runs as root, so no need for all the "sudo" stuff in front of
# every command.
#
# To debug, the logfile produced by Amazon is in /var/log/cloud-init-output.log

USR=accord
PASS=AP4GxDHU2f6EriLqry781wG6fy
ART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory
GRADLEVER=gradle-2.6
JENKINS_CONFIG_TAR=jnk-lnx-conf.tar
JENKINS_JOBS_TAR=jnk-lnx-jobs.tar

EXTERNAL_HOST_NAME=$( curl http://169.254.169.254/latest/meta-data/public-hostname )
${EXTERNAL_HOST_NAME:?"Need to set EXTERNAL_HOST_NAME non-empty"}

artf_get() {
    echo "Downloading $1/$2"
    wget -O "$2" --user=$USR --password=$PASS ${ART}/"$1"/"$2"
}

#
#  update all the out-of-date packages
#
yum -y update

#
# install Open Java 1.8, git, md5sum
#
yum -y install java-1.8.0-openjdk-devel.x86_64
# yum -y install golang-pkg-bin-linux-amd64.x86_64
# yum -y install golang-cover.x86_64
# yum -y install golang-vet.x86_64
yum -y install git-all.noarch
yum -y install isomd5sum.x86_64

#
# install gradle
#
wget https://services.gradle.org/distributions/${GRADLEVER}-bin.zip
unzip ${GRADLEVER}-bin.zip
mv ${GRADLEVER} /usr/local
ln -s /usr/local/${GRADLEVER}/bin/gradle /usr/bin/gradle
rm ${GRADLEVER}-bin.zip

#  Install go 1.51.  The yum installs that amazon provides are
#  (or at least were) for version 1.42. I've already made use
#  of 1.5 features.
wget https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.5.1.linux-amd64.tar.gz

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
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
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
artf_get ext-tools/utils ottoaccord.tar.gz
artf_get ext-tools/utils accord-linux.tar.gz
artf_get ext-tools/jenkins ${JENKINS_CONFIG_TAR}
artf_get ext-tools/jenkins ${JENKINS_JOBS_TAR}

echo "Installing /usr/local/accord"
cd /usr/local
tar xvzf ~/accord-linux.tar.gz

echo "Updating credentials for user 'jenkins' to access github"
cd ~jenkins
tar xvzf ~/ottoaccord.tar.gz

#  update everybody's path so go will work nicely
chmod 0666 ~ec2-user/.bash_profile
echo "GOROOT=/usr/local/go" >> ~ec2-user/.bash_profile
echo "ACCORD=/usr/local/accord" >> ~ec2-user/.bash_profile
echo "export GOROOT" >> ~ec2-user/.bash_profile
echo "export ACCORD" >> ~ec2-user/.bash_profile
echo "PATH=${PATH}:${GOROOT}/bin:${ACCORD}/bin:${ACCORD}/testtools" >> ~ec2-user/.bash_profile
chmod 0644 ~ec2-user/.bash_profile
chmod 0666 ~jenkins/.bash_profile
echo "GOROOT=/usr/local/go" >> ~jenkins/.bash_profile
echo "export GOROOT" >> ~jenkins/.bash_profile
echo "export ACCORD" >> ~jenkins/.bash_profile
echo "ACCORD=/usr/local/accord" >> ~jenkins/.bash_profile
echo "PATH=${PATH}:${GOROOT}/bin:${ACCORD}/bin:${ACCORD}/testtools" >> ~jenkins/.bash_profile
chmod 0644 ~jenkins/.bash_profile

echo "Sleeping for 30 seconds to give Jenkins plenty of time to"
echo "complete its initial startup."
sleep 30

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

cd ~
rm ./*.gz

# set the timezone to Pacific
cd /etc
mv localtime localtime.old
ln -s /usr/share/zoneinfo/US/Pacific localtime
cd


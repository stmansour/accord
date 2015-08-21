#!/bin/bash
#
# Setup a Jenkins instance for Java builds on amazon's linux
# This script is designed to be run only during the first boot cycle.
# It runs as root, so no need for all the "sudo" stuff in front of
# every command.
#
#
# You MUST set this environment
#

USR=accord
PASS=AP4GxDHU2f6EriLqry781wG6fy
ART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory
EXTERNAL_HOST_NAME=$( curl http://169.254.169.254/latest/meta-data/public-hostname )
${EXTERNAL_HOST_NAME:?"Need to set EXTERNAL_HOST_NAME non-empty"}

artf_get() {
    echo "Downloading $1/$2"
    wget -O $2 --user=$USR --password=$PASS ${ART}/$1/$2
}

echo "Hi. I am $EXTERNAL_HOST_NAME." > /tmp/HiSteve.txt
pwd >> /tmp/HiSteve.txt

#
#  update all the out-of-date packages
#
yum -y update

#
# install Open Java 1.8
#
yum -y install java-1.8.0-openjdk-devel.x86_64

#
# install git
#
yum -y install git-all.noarch

#
#  we will also need md5sum and sha1sum
#
yum -y install isomd5sum.x86_64

#
# install gradle
#
wget https://services.gradle.org/distributions/gradle-2.5-bin.zip
unzip gradle-2.5-bin.zip
mv gradle-2.5 /usr/local
ln -s /usr/local/gradle-2.5/bin/gradle /usr/bin/gradle
rm gradle-2.5-bin.zip

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

echo "Installing /usr/local/accord"
cd /usr/local
tar xvzf ~/accord-linux.tar.gz

echo "Updating credentials for user 'jenkins' to access github"
cd ~jenkins
tar xvzf ~/ottoaccord.tar.gz
chown -R jenkins:jenkins .ssh
cd ~
rm *.gz


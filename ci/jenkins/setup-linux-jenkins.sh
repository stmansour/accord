#!/bin/bash
##############################################################
# Setup a Jenkins instance for Java builds on amazon's linux
##############################################################
export FORGOT="You forgot"

#
# You MUST set this environment
#
export EXTERNAL_HOST_NAME=ec2-52-0-20-212.compute-1.amazonaws.com

if [ "$FORGOT" = "$EXTERNAL_HOST_NAME" ]; then
    echo " ";
    echo " ";
    echo "Oh my! You forgot to set the externally visible host name didn't you?"
    echo "It should look something like this: ec2-52-3-151-221.compute-1.amazonaws.com"
    echo "Please edit this script and set EXTERNL_HOST_NAME to the externally"
    echo "visible name and try again."
    echo " ";
    echo " ";
    exit 1
fi

#
#  update all the out-of-date packages
#
sudo yum -y update

#
# install Open Java 1.7
#
sudo yum -y install java-1.7.0-openjdk-devel.x86_64

#
# install git
#
sudo yum -y install git-all.noarch

#
#  we will also need md5sum and sha1sum
#
sudo yum -y install isomd5sum.x86_64

#
# install gradle
#
wget https://services.gradle.org/distributions/gradle-2.5-bin.zip
unzip gradle-2.5-bin.zip
sudo mv gradle-2.5 /usr/local
sudo ln -s /usr/local/gradle-2.5/bin/gradle /usr/bin/gradle
rm gradle-2.5-bin.zip

#
#  add user 'jenkins' before installing jenkins. The default installation
#  creates the 'jenkins' user, but sets the shell to /bin/zero.  Unfortunately,
#  this renders much of the su - jenkins script automation unusable. But if
#  the jenkins user already exists, everything will be fine
#
sudo adduser -d /var/lib/jenkins jenkins

#
#  install jenkins
#
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins
sudo service jenkins start
sudo chkconfig jenkins on

#
# jenkins listens on port 8080
# map port 80 http traffic to port 8080 with njinx
#
sudo yum -y install nginx

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

sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original
sudo mv -f my.conf /etc/nginx/nginx.conf
sudo chmod 0644 /etc/nginx/nginx.conf

#
# Start nginx and ensure that it starts on boot:
#
sudo service nginx start
sudo chkconfig nginx on

#
# Setup the 'jenkins' user to be identified as ottoaccord :-)
# The ssh keys for ottoaccord are in ottoaccord.tar
#
sudo cat > qq_genkey_qq << EOF
#!/bin/bash
cd ~jenkins
tar xvf ottoaccord.tar
chown -R jenkins:jenkins .ssh
EOF
sudo chmod +x qq_genkey_qq
sudo mv qq_genkey_qq ~jenkins/
sudo cp ottoaccord.tar ~jenkins/
sudo su -c './qq_genkey_qq' - jenkins
sudo rm ~jenkins/qq_genkey_qq
sudo rm ~jenkins/ottoaccord.tar
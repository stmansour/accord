#!/bin/bash
#  1. Create new compute instance
#       From the AWS dashboard:
#	- Launch Instance
#	- AMI: select Amazon Linux AMI 2015.03 (HVM), SSD Volume Type - ami-1ecae776
#	- Instance Type:  select General purpose t2.micro
#	- Configure Security Group - allow access for SSH (port 22) and TCP, (port 80)
#	- Launch
#
#  2. Edit 'setup-linux' and set EXTERNAL_HOST_NAME to use the new minstance Public DNS name.
#
#  3. Upload 'setup-linux' and ottobldrssh.tar to the new machine.
#       Name:  Otto Accord
#       Email: ottoaccord@gmail.com
#       PW:    0tt0acc0rd
#       accounts on gmail and github.  This user will be associated with Jenkins (or 
#       whatever) automated builds and will have permission to write to Artifactory
#       in the jenkins-snapshot/release area.

if [ -e ottoaccord.tar.gz ]; then
    gunzip ottoaccord.tar.gz
fi

echo -n "Target hostname: "
read hostname
scp -i ~/.ssh/smanAWS1.pem setup-linux-jenkins.sh ottoaccord.tar ec2-user@${hostname}:~/

#scp -i ~/.ssh/smanAWS1.pem setup-linux ottobldrssh.tar ec2-user@ec2-52-2-162-170.compute-1.amazonaws.com:~/

#  4. ssh to the new instance. An easy way to do this is to update the ~/.ssh/config
#     file with info about the new instance, something like the following:
#
#       Host jenkins
#               Hostname     ec2-52-0-148-174.compute-1.amazonaws.com
#               User         ec2-user
#               IdentityFile ~/.ssh/smanAWS1.pem
#     
#     Then log into the new instance. With the above updates to ~/.ssh/config, you
#     can enter:
#
#	ssh jenkins
#
#  5. Run the setup script. Note: part of the setup script executes 'sudo yum update',
#     so you can disregard the login message that asks you to do this.
#
#	chmod +x setup-linux ; ./setup-linux
#
#     This adds OpenJava 1.7, git, and gradle 2.5. It also installs Jenkins and sets
#     up an njinx proxy that forwards port 80 requests to port 8080 (jenkins default).
#     This is just a convenience so that people don't need to add the port number
#     to the URLs for accessing Jenkins.
#
#  6. As part of this script, a key pair has been created for the 'jenkins' user so that
#     it can access source code from GitHub securely. Copy or note the public key for
#     use later. It can be shared with jenkins users.
#
#	To use this key, go into GitHub and after selecting the repository you are
#       interested in:
#		- click the 'Settings' button on the right
#		- click the 'Deploy keys' link on the left
#		- click the 'Add deploy key' button (right top of table)
#		- give the new key a name under Title, and paste in the
#		  public key data in the Key area.
#
#  8. When the script completes, the jenkins service should be running and you should
#     be able to point a browser at the new instance and see jenkins.  For this example,
#     the url would be:
#
#	http://ec2-52-0-148-174.compute-1.amazonaws.com/
#
#  9. Next, we must configure Jenkins. <<need to figure out automation for this>>
#     	- click Manage Jenkins
#	- click Enable Security
#	- Jenkins' own user database
#	- uncheck 'Allow users to sign up'   (we'll add the folks we want)
#	- Logged-in users can do anything    (we'll review this later)
#	- Save
#
#       This should lead to a Sign up page.  Add the admin user, then click
#	Manage Jenkins again, then Manage Users, then add the remaining users.
# 
#	- Update all the plugins that need updating (they're on the first tab)
#	  don't reboot just yet.
#	- go to the Available tab, filter with 'github ', then check the GitHub plugin
#	- click 'Download now and install after restart' . this will take a few mins
#
#	This should be enough to create a job and make sure your installation is
#	functioning.  Here's a sample repository: git@github.com:stmansour/sort.git
#
# 10. Add any further plugins we want for Jenkins and restart.  Currently, for
#     Java development we use:
#	- Jacoco coverage report
#	- Violations plugin
#       - Artifactory plugin
#       - Gradle plugin
#	- GIT plugin
#
# 11. Configure Jenkins - (for windows...)
#	jdk	- name: JDK 1.8
#	          JAVA_HOME:  c:\Program Files\Java\jdk1.8.0_51
#       git	- name: git version 1.9.5 mysysgit.1
#                 path: c:\Program Files (x86)\Git\cmd
#       gradle 	- name: Gradle 2.6
#		  GRADLE_HOME:  c:\Accord\gradle
#
# 12. In GitHub, add the webhook in so that Jenkins builds automatically.
#     On the GitHub UI, go to the repo for which you want to set up the automated
#     build, on the right side of the screen click "Settings", then click
#     "Webhooks & Services". Under the Services list on the left side click the
#     "Add Service" dropdown, in the filter area type "Jenkins", and select
#     "Jenkins (GitHub plugin).
#
#     There can only be only 1 GitHub webhook per repo (this is unfortunate).
#     If you already have one and you try to add
#     a second, "Jenkins (GitHub plugin)" will not be listed under Add Service
#
#     After adding the Jenkins GitHub plugin service, configure it with the
#     URL to jenkins. It will be something like:
#	http://ec2-52-0-148-174.compute-1.amazonaws.com/github-webhook/
#     In Jenkins, go to Manage Jenkins, then Configure System, at the bottom
#     of the page under GitHub Web Hook, select "Manually manage hook URLs" then click
#     the help button (?) on the right. It will list the URL to use.
#     

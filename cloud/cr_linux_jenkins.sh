#!/bin/bash
#  This script creates a new running instance of the linux Jenkins build server.
#  The server is configured with the last known backup of our running server.
#  The jobs from the last backup are also restored.

pushd /usr/local/accord/bin
aws ec2 run-instances --output json --image-id ami-1ecae776 --count 1 --instance-type t2.micro --key-name smanAWS1  --security-groups Linux-Jenkins-CI  --user-data file://setup-linux-jenkins.sh > new-linux-jenkins-instance.json
popd
date

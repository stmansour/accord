#!/bin/bash
date
aws ec2 run-instances --output json --image-id ami-1ecae776 --count 1 --instance-type t2.micro --key-name smanAWS1  --security-groups Linux-Jenkins-CI  --user-data file://setup-linux-jenkins.sh > new-linux-jenkins-instance.json

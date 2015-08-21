#!/bin/bash
aws ec2 run-instances --image-id ami-1ecae776 --count 1 --instance-type t2.micro --key-name smanAWS1  --security-groups Linux-Jenkins-CI  --user-data file://setup-linux-jenkins.sh

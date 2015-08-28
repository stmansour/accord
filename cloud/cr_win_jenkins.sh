#!/bin/bash
pushd /usr/local/accord/bin
aws ec2 run-instances --output json --image-id ami-6f2cf804 --count 1 --instance-type t2.micro --key-name smanAWS1  --security-groups Windows-Jenkins --user-data file://winjenk.scr > new-windows-jenkins-instance.json
popd
date

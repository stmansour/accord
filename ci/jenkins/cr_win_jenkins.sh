#!/bin/bash
aws ec2 run-instances --image-id ami-6f2cf804 --count 1 --instance-type t2.micro --key-name smanAWS1  --security-groups Windows-Jenkins --user-data file://winjenk.scr

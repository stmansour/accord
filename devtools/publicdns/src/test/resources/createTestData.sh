#!/bin/bash
# This script modifies generic.json so that a match should be found
# when a test runs on this computer.

HOST="$( hostname )"
HOST=${HOST%%.*}
echo "Host = $HOST"
cat generic.json | sed "s/ip-172-31-55-36\.ec2\.internal/${HOST}.ec2.internal/" > test1.json

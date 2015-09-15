#!/bin/bash
HOSTNAME=localhost
PORT=8123

if [ "x" != "x$1" ]; then
	PORT=$1
fi

if [ $(uname) == "Linux" ]; then
	HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
fi

echo "http://${HOSTNAME}:${PORT}/" > phonehome
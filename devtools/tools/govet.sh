#!/bin/bash

d=$(/usr/local/accord/bin/symlinks_in_path.sh)
if [ "x${d}" != "x" ]; then
	cd ${d}
fi
go vet


#!/bin/bash
# A simple script to create the directory skeleton of a java app.
# This will give us consistent directory structures for all the 
# components of this project.
#
# It assumes we'll be using gradle for the build.
#
# To install, just copy all the files begining with 'appdirbuild'
# to a directory in your path.  For example:
# 	cp appdirbuild* ~/bin/
#
# Author: sman

if [ -z $1 ]; then
    echo "you must supply the project name (top level directory name)"
    exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

declare -a arr=(
	"src"
	"src/main"
	"src/main/java"
	"src/main/resources"
	"config"
	"config/checkstyle"
	"src/test"
	"src/test/java"
	"src/test/resources")

if [ ! -d $1 ]; then
    mkdir $1
fi

for i in "${arr[@]}"
do
    echo "$1/$i"
    mkdir $1/$i
done

cp $DIR/appdirbuild.build.gradle $1/build.gradle
cp $DIR/appdirbuild.generic.xml $1/config/checkstyle/generic.xml
cp $DIR/appdirbuild.checkstyle-noframes-sorted.xsl $1/config/checkstyle/checkstyle-noframes-sorted.xsl

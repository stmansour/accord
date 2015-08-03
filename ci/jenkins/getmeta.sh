# Artifactory location
server=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory
repo=jenkins-snapshot

# Maven artifact location
name=sort-1.1.0.jar
artifact=sort/sman/$name
path=$server/$repo/$artifact
echo "path = $path"

version=`curl -s $path/maven-metadata.xml`
echo $version
#version=`curl -s $path/maven-metadata.xml | grep latest | sed "s/.*<latest>\([^<]*\)<\/latest>.*/\1/"`
#build=`curl -s $path/$version/maven-metadata.xml | grep '<value>' | head -1 | sed "s/.*<value>\([^<]*\)<\/value>.*/\1/"`
#jar=$name-$build.jar
#url=$path/$version/$jar

# Download
#echo $url
#wget -q -N $url

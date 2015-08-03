# Artifactory location
server=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory
repo=jenkins-snapshot/sort/sman
name=sort-1.1.0.jar
artifact=sort/sman/$name

artifactoryUser="ottoaccord"
artifactoryPassword="0tt0acc0rd"

folderURI=$server/api/storage/$repo

echo "folderURI = $folderURI"
curl -i -X GET -u $artifactoryUser:$artifactoryPassword $folderURI

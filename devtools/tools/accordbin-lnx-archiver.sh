#!/bin/bash
#
# sman
# Ver 1.0

ACCORD_BIN=/usr/local/accord/bin
ARTIFACT=accord-linux.tar

#
#  $1 = artifactory path
#  $2 = filename
#
artf_update () {
    if [ ! -f "$2" ]; then
        echo "File $2 does not exist"
        exit 1
    else
        echo "removing $1/$2"
        ${ACCORD_BIN}/rmfile.sh "$1/$2"
        echo "adding $2 to $1"
        ${ACCORD_BIN}/deployfile.sh "$2" "$1"
    fi  
}

pushd /usr/local/
tar cvf /tmp/${ARTIFACT} accord
pushd /tmp
echo "Storing ${ARTIFACT}.gz to Artifactory:/ext-tools/utils"
gzip ${ARTIFACT}
artf_update ext-tools/utils ${ARTIFACT}.gz
popd
popd

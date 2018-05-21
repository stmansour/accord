#!/bin/bash

# symlinks_in_path.sh returns a count of the number of symlinks
# that are in the supplied path. If the count is > 0 then it
# outputs an equivalent path with no embeded symbolic links.

# This script is needed because 'go vet' does not work correctly
# when a symlink is in the source path.

set -f
G=$(echo "${GOPATH}" | tr "/" ":")
Gparts=(${G//:/ })
P=$(pwd | tr "/" ":")
Pparts=(${P//:/ })
lenG=${#Gparts[@]}
lenP=${#Pparts[@]}

np=""
for (( i = 0; i < lenG-1; i++ )); do
        np="${np}/${Pparts[i]}"
done

tot=0 
for (( i = lenG-1; i <= lenP; i++ )); do
        np="${np}/${Pparts[i]}"
        if [[ -L "${np}" && -d "${np}" ]]; then
                # echo "Found symbolic link at: ${np}"
                tot=$((tot + 1))
                np=$(readlink -f "${np}")
        fi
done

if [ ${tot} -gt 0 ]; then
        echo "${np}"
fi

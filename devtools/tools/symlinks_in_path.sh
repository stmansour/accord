#!/bin/bash

# symlinks_in_path.sh returns a count of the number of symlinks
# that are in the supplied path.

# string="1:2:3:4:5"
# set -f                      # avoid globbing (expansion of *).
# array=(${string//:/ })
# for i in "${!array[@]}"
# do
#     echo "$i=>${array[i]}"
# done 

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
                tot=$((tot + 1))
                # echo "Found symbolic link at: ${np}"
        fi
done

echo "${tot}"

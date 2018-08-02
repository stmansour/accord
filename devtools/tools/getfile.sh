#!/bin/bash
VERBOSE=0
WGETOPTS="-q"

usage() {
    cat <<ZZEOF
Purpose: Download a file from artifactory to the local system
Usage:   $0 [options] remotefilepath

options:
-m <chown permissions>    # set permissions after download
-v                        # verbose mode, helps if debugging an issue

Examples:

$0  ext-tools/utils/s.bat
	This command will download s.bat from Artifactory directory ext-tools/utils

$0	-m 400 accord/db/confdev.json
	Download confdev.json, set its permissions to 400 (only owner can read)

ZZEOF
}

while getopts ":m:v" o; do
    case "${o}" in
    	m)
            MODE=${OPTARG}
            ;;
        v)
			VERBOSE=1
			;;
        *)
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

for arg do
	remoteFile=${arg}
	rfbase=$(basename ${remoteFile})
	if [ -e ${rfbase} ]; then
		mv -f ${rfbase} ${rfbase}.save
	fi
	APATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
	ARTIF=${APATH}/artifactory.url
	ARTPSW=${APATH}/credp
	targetPath=$(cat ${ARTIF})
	artp=$(cat ${ARTPSW})
	artu="accord"

	if [ ${VERBOSE} -gt 0 ]; then
		echo "reading from ${targetPath}"
		echo "wget --user=${artu} --password=${artp} ${targetPath}/${remoteFile}"
		WGETOPTS=
	fi
	wget ${WGETOPTS} --user=${artu} --password=$artp ${targetPath}/"${remoteFile}" >/dev/null

	if [ -e ${rfbase} ]; then
		if [ "${MODE}" != "" ]; then
			chmod ${MODE} ${rfbase}
		fi
		rm -f ${rfbase}.save
	else
		echo "failed to download requested file"
		if [ -e ${rfbase}.save ]; then
			mv ${rfbase}.save ${rfbase}
		fi
	fi
	exit 0
done

usage
exit 1

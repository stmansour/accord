TOP=../..
THISDIR=tools
INSTALLDIR=/usr/local/accord/bin
PACKAGEDIR=${TOP}/tmp/accord/bin

FILES=artifactory.url credp deployfile.sh getfile.sh jnk-lnx-conf-archiver.sh jnk-lnx-job-archiver.sh publicdns getfile.sh rmfile.sh updatefile.sh symlinks_in_path.sh govet.sh

tools:
	@echo "*** COMPLETE in ${THISDIR} ***"

all: install package publish
	@echo "*** COMPLETE ***"

install:
	for f in $(FILES); do cp $$f ${INSTALLDIR};done
	@echo "*** INSTALL COMPLETE in ${THISDIR} ***"

package:
	mkdir -p ${PACKAGEDIR}
	for f in $(FILES); do cp $$f ${PACKAGEDIR};done
	@echo "*** PACKAGE COMPLETE in ${THISDIR} ***"

publish:
	@echo "*** PUBLISH COMPLETE in ${THISDIR} ***"

clean:
	@echo "*** CLEAN COMPLETE in ${THISDIR} ***"

TOP=..
INSTALLDIR=/usr/local/accord/bin
PACKAGEDIR=${TOP}/tmp/accord/bin
THISDIR=cloud

clean:
	@echo "*** CLEAN COMPLETE in ${THISDIR} ***"

all: install package publish
	@echo "*** COMPLETE in ${THISDIR} ***"

install:
	cp cr_win_jenkins.sh cr_linux_jenkins.sh ${INSTALLDIR}
	cp cr_win_testenv.sh cr_linux_testenv.sh ${INSTALLDIR}
	cp qmaster.sh qmaster.scr? ${INSTALLDIR}
	cp cr_win_pow.sh pow.scr ${INSTALLDIR}
	@echo "*** INSTALL COMPLETE in ${THISDIR} ***"

package:
	mkdir -p ${PACKAGEDIR}
	cp cr_linux_jenkins.sh ${PACKAGEDIR}
	cp cr_linux_testenv.sh ${PACKAGEDIR}
	cp qmaster.* ${PACKAGEDIR}
	@echo "*** PACKAGE COMPLETE in ${THISDIR} ***"

publish:
	@echo "*** PUBLISH COMPLETE in ${THISDIR} ***"

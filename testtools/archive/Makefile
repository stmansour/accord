TOP=../..
THISDIR=archive
INSTALLDIR=/usr/local/accord/testtools
PACKAGEDIR=${TOP}/tmp/accord/testtools

archive:
	@echo "*** COMPLETED in ${THISDIR} **"

all: clean archive  test
	@echo "*** COMPLETED in ${THISDIR} **"

clean:
	@echo "*** CLEAN COMPLETED in ${THISDIR} ***"

test: 
	@echo "*** TEST COMPLETED in ${THISDIR} ***"

install: uhura_shutdown.sh
	mkdir -p ${INSTALLDIR}
	cp uhura_shutdown.sh clientsim.sh ${INSTALLDIR}
	@echo "*** INSTALL COMPLETED in ${THISDIR} ***"

package: uhura_shutdown.sh
	mkdir -p ${PACKAGEDIR}
	cp uhura_shutdown.sh ${PACKAGEDIR}

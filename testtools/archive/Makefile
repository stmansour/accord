TOP=../..
THISDIR=archive
INSTALLDIR=/usr/local/accord/testtools
PACKAGEDIR=${TOP}/tmp/accord/testtools

archive:
	@echo "*** COMPLETED in ${THISDIR} **"

all: clean testreporter test
	@echo "*** COMPLETED in ${THISDIR} **"

clean:
	@echo "*** CLEAN COMPLETED in ${THISDIR} ***"

test: testreporter
	@echo "*** TEST COMPLETED in ${THISDIR} ***"

install: testreporter
	mkdir -p ${INSTALLDIR}
	cp uhura_shutdown.sh ${INSTALLDIR}
	@echo "*** INSTALL COMPLETED in ${THISDIR} ***"

package: testreporter
	mkdir -p ${PACKAGEDIR}
	cp uhura_shutdown.sh ${PACKAGEDIR}

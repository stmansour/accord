TOP=../..
THISDIR=testreporter
INSTALLDIR=/usr/local/accord/testtools
PACKAGEDIR=${TOP}/tmp/accord/testtools

testreporter:
	go vet
	if [[ `uname` = "Darwin" ]]; then echo "staticcheck"; else echo "golint"; fi
	if [[ `uname` = "Darwin" ]]; then staticcheck; else golint; fi
	go build

all: clean testreporter test
	@echo "*** COMPLETED in ${THISDIR} **"

clean:
	rm -f testreporter
	@echo "*** CLEAN COMPLETED in ${THISDIR} ***"

test: testreporter
	@echo "*** TEST COMPLETED in ${THISDIR} ***"

install: testreporter
	mkdir -p ${INSTALLDIR}
	cp testreporter ${INSTALLDIR}
	@echo "*** INSTALL COMPLETED in ${THISDIR} ***"

package: testreporter
	mkdir -p ${PACKAGEDIR}
	cp testreporter ${PACKAGEDIR}

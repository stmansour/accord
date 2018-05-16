TOP=..
INSTALLDIR = /usr/local/accord/bin
PACKAGEDIR=${TOP}/accord/bin
THISDIR="jenkins"

clean:
	@echo "CLEAN COMPLETE in ${THISDIR}"

all: clean install package publish
	@echo "*** COMPLETED ***"

install:
	mkdir -p ${INSTALLDIR}
	if [ ! -d $(INSTALLDIR) ]; then mkdir -p $(INSTALLDIR); fi
	cp setup-linux-jenkins.sh $(INSTALLDIR)
	@echo "*** INSTALL COMPLETE in ${THISDIR} ***"

package:
	mkdir -p ${PACKAGEDIR}
	cp setup-linux-jenkins.sh $(PACKAGEDIR)
	@echo "*** PACKAGE COMPLETE in ${PACKAGEDIR} ***"

publish:
	@echo "*** PUBLISH COMPLETE in ${THISDIR} ***"

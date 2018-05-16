DIRS=tools
THISDIR=devtools
TOP=..

devtools:
	for dir in $(DIRS); do make -C $$dir ;done
	@echo "*** COMPLETE in ${THISDIR} ***"

clean:
	for dir in $(DIRS); do make -C $$dir clean;done
	@echo "*** CLEAN COMPLETE in ${THISDIR} ***"

install:
	for dir in $(DIRS); do make -C $$dir install;done
	@echo "*** INSTALL COMPLETE in ${THISDIR} ***"

package:
	for dir in $(DIRS); do make -C $$dir package;done
	@echo "*** PACKAGE COMPLETE in ${THISDIR} ***"

publish:
	for dir in $(DIRS); do make -C $$dir publish;done
	@echo "*** PUBLISH COMPLETE in ${THISDIR} ***"

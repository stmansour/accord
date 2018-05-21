top=..
DIRS=testreporter archive
THISDIR=testtools


testtools:
	for dir in $(DIRS); do make -C $$dir ;done

all: clean test
	@echo "*** CLEAN COMPLETED in ${THISDIR} **"

clean:
	for dir in $(DIRS); do make -C $$dir clean;done
	@echo "*** CLEAN COMPLETED in ${THISDIR} ***"

test:
	for dir in $(DIRS); do make -C $$dir test;done
	@echo "*** TEST COMPLETED in ${THISDIR} ***"

install:
	for dir in $(DIRS); do make -C $$dir install;done
	@echo "*** INSTALL COMPLETED in ${THISDIR} ***"

package:
	for dir in $(DIRS); do make -C $$dir package;done
	@echo "*** PACKAGE COMPLETED in ${THISDIR} ***"

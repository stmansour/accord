DIRS=ci cloud devtools testtools
THISDIR=accord

accord:
	for dir in $(DIRS); do make -C $$dir ; done

install:	
	for dir in $(DIRS); do make -C $$dir install;done
	@echo "*** INSTALL COMPLETE in ${THISDIR} ***"

all: clean install package
	@echo "*** COMPLETE ***"

clean:
	rm -rf tmp
	for dir in $(DIRS); do make -C $$dir clean;done
	cd ./devtools;make clean
	cd ./testtools;make clean
	@echo "*** CLEAN COMPLETE in ${THISDIR} ***"

package:
	rm -rf tmp
	mkdir -p tmp/accord/bin
	mkdir -p tmp/accord/testtools
	for dir in $(DIRS); do make -C $$dir package;done
	@echo "*** PACKAGE COMPLETE in ${THISDIR} ***"

publish:
	cd tmp;tar cvf accord-linux.tar accord;gzip -f accord-linux.tar
	cd tmp;updatefile.sh ext-tools/utils accord-linux.tar.gz
	@echo "*** PACKAGE COMPLETE in ${THISDIR} ***"

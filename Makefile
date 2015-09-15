all: clean install package publish
	@echo "*** COMPLETE ***"

clean:
	cd ./devtools;make clean
	@echo "*** CLEAN COMPLETE in accord ***"

install:	
	cd ./ci;make install
	cd ./cloud;make install
	cd ./devtools;make install
	@echo "*** INSTALL COMPLETE in accord ***"

package:
	cd ./ci;make package
	cd ./cloud;make package
	cd ./devtools;make package
	cd /usr/local;tar cvf accord-linux.tar accord
	mv /usr/local/accord-linux.tar .
	gzip -f accord-linux.tar
	@echo "accord-linux.tar.gz ready for publishing"
	@echo "*** PACKAGE COMPLETE in accord ***"

publish:
	cd ./ci;make publish
	cd ./cloud;make publish
	cd ./devtools;make publish
	updatefile.sh ext-tools/utils accord-linux.tar.gz
	@echo "*** PACKAGE COMPLETE in accord ***"

install:
	cd ./tools;make install
	cd ./publicdns;make install
	@echo "*** INSTALL COMPLETE in devtools ***"

package:
	cd ./tools;make package
	cd ./publicdns;make package
	cd /usr/local;tar cvf accord-linux.tar accord
	mv /usr/local/accord-linux.tar .
	gzip -f accord-linux.tar
	@echo "accord-linux.tar.gz ready for publishing"
	@echo "*** PACKAGE COMPLETE in devtools ***"

publish:
	cd ./tools;make publish
	cd ./publicdns;make publish
	updatefile.sh ext-tools/utils accord-linux.tar.gz
	@echo "*** RELEASE COMPLETE in devtools ***"

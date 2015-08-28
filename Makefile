all: install package publish
	@echo "*** COMPLETE ***"

install:	
	cd ./ci;make install
	cd ./cloud;make install
	cd ./devtools;make install
	@echo "*** INSTALL COMPLETE in accord ***"

package:
	cd ./ci;make package
	cd ./cloud;make package
	cd ./devtools;make package
	@echo "*** PACKAGE COMPLETE in accord ***"

publish:
	cd ./ci;make publish
	cd ./cloud;make publish
	cd ./devtools;make publish
	@echo "*** PACKAGE COMPLETE in accord ***"

all: install package publish
	@echo "*** COMPLETE ***"
install:
	cp *.sh /usr/local/accord/bin
	@echo "*** INSTALL COMPLETE in tools ***"

package:
	@echo "*** PACKAGE COMPLETE in tools ***"

publish:
	updatefile.sh ext-tools/utils jnk-win-conf-archiver.sh
	updatefile.sh ext-tools/utils jnk-win-job-archiver.sh
	updatefile.sh ext-tools/utils getfile.sh
	updatefile.sh ext-tools/utils deployfile.sh
	updatefile.sh ext-tools/utils updatefile.sh
	updatefile.sh ext-tools/utils rmfile.sh
	@echo "*** PUBLISH COMPLETE in tools ***"

all: install package publish
	@echo "*** COMPLETE in cloud ***"

install:
	cp cr_win_jenkins.sh cr_linux_jenkins.sh ~/bin/
	@echo "*** INSTALL COMPLETE in cloud ***"

package:
	@echo "*** PACKAGE COMPLETE in cloud ***"

publish:
	updatefile.sh ext-tools/utils cr_win_jenkins.sh
	updatefile.sh ext-tools/utils cr_linux_jenkins.sh
	@echo "*** PUBLISH COMPLETE in cloud ***"

all: install package publish
	@echo "*** COMPLETE in cloud ***"

install:
	cp cr_win_jenkins.sh cr_linux_jenkins.sh /usr/local/accord/bin
	cp cr_win_testenv.sh cr_linux_testenv.sh /usr/local/accord/bin
	cp qmaster.sh qmaster.scr? /usr/local/accord/bin
	@echo "*** INSTALL COMPLETE in cloud ***"

package:
	@echo "*** PACKAGE COMPLETE in cloud ***"

publish:
	updatefile.sh ext-tools/utils cr_win_jenkins.sh
	updatefile.sh ext-tools/utils cr_win_testenv.sh
	updatefile.sh ext-tools/utils cr_linux_jenkins.sh
	updatefile.sh ext-tools/utils cr_linux_testenv.sh
	updatefile.sh ext-tools/utils qmaster.sh
	updatefile.sh ext-tools/utils qmaster.scr1
	updatefile.sh ext-tools/utils qmaster.scr2
	@echo "*** PUBLISH COMPLETE in cloud ***"

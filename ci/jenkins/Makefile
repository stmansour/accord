BINLOC = /usr/local/accord/bin

all: install package publish
	@echo "*** COMPLETED ***"

install:
	if [ ! -d $(BINLOC) ]; then mkdir -p $(BINLOC); fi
	cp setup-linux-jenkins.sh setup-win-jenkins.bat winjenk.scr $(BINLOC)
	@echo "*** INSTALL COMPLETE in jenkins ***"

package:
	@echo "*** PACKAGE COMPLETE in jenkins ***"

publish:
	./publish-scripts.sh
	@echo "*** PUBLISH COMPLETE in jenkins ***"

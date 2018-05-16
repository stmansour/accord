DIRS=artifactory jenkins

install:
	for dir in $(DIRS); do make -C $$dir install;done
	@echo "*** INSTALL COMPLETE in ci ***"

package:
	for dir in $(DIRS); do make -C $$dir package;done
	@echo "*** INSTALL COMPLETE in ci ***"

publish:
	for dir in $(DIRS); do make -C $$dir publish;done
	@echo "*** INSTALL COMPLETE in ci ***"

clean:
	for dir in $(DIRS); do make -C $$dir clean;done
	@echo "*** CLEAN COMPLETE in ci ***"


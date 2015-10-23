all: clean test
	@echo "*** COMPLETED in tools **"

clean:
	cd testreporter;make clean
	@echo "*** CLEAN COMPLETED in tools ***"

test:
	cd testreporter;make test
	@echo "*** TEST COMPLETED in tools ***"

install:
	cd testreporter;make install
	if [ ! -d /usr/local/accord/testtools ]; then mkdir /usr/local/accord/testtools; fi
	cp *.sh /usr/local/accord/testtools/
	@echo "*** INSTALL COMPLETED in tools ***"

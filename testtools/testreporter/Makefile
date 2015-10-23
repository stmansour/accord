all: clean testreporter test
	@echo "*** COMPLETED in testreporter **"

testreporter:
	go vet
	golint
	go build

clean:
	rm -f testreporter
	@echo "*** CLEAN COMPLETED in testreporter ***"

test: testreporter
	@echo "*** TEST COMPLETED in testreporter ***"

install: testreporter
	if [ ! -d /usr/local/accord/testtools ]; then mkdir /usr/local/accord/testtools; fi
	cp testreporter /usr/local/accord/testtools/
	@echo "*** INSTALL COMPLETED in testreporter ***"

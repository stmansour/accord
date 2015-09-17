#!/bin/bash
# Before doing anything we need to set some environment
# variables so that ldap will be able to successfully
# complete its configure.  Check to see if we have the
# environment variables already install. If not, update
# the bashrc_profile, stop the script, and ask to be
# restarted.

BDBFILE=db5
BDB_MAJ_MIN=5.3
BDBVER=${BDB_MAJ_MIN}.28

M=$(grep CPPFLAGS ~/.bashrc-local)
if [ "x" == "x$M ]; then
	# the configure program in ldap needs to be able to find
	# the version of Berkeley DB we installed. 
	# Note:  openldap will only work with bdb versions > 4.4 and
	#        less than 6.1
cat << EOF >> ~/.bash_profile
export CPPFLAGS=-I/usr/local/BerkeleyDB.${BDB_MAJ_MIN}/include
export LDFLAGS=-L/usr/local/BerkeleyDB.${BDB_MAJ_MIN}/lib
export LD_LIBRARY_PATH=/usr/local/BerkeleyDB.${BDB_MAJ_MIN}/lib
EOF

	echo "Sorry for the interruption..."
	echo "Please issue the following command then rerun this script:"
	echo " "
	echo ". ~/.bash_profile"
fi

sudo yum -y install gcc44.x86_64

#
# We need berkeley db first...
#
/usr/local/accord/bin/getfile.sh ext-tools/utils/${BDBFILE}.gz
gunzip ${BDBFILE}.gz
tar xvf ${BDBFILE}
cd db-${BDBVER}/build_unix
../dist/configure
make
sudo make install
 
cd ../..

wget ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.42.tgz
gunzip -c openldap-2.4.42.tgz | tar xvfB -
cd openldap-2.4.42
./configure
make depend
make
make test
sudo make install

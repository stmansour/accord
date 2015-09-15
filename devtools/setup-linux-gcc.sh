# This script checks out what we need to do C, C++ compiles and
# debugging on Amazon Linux instances.
#!/bin/bash
yum -y install gcc48-plugin-devel.x86_64
yum -y install libgcc48.x86_64
yum -y install gcc48.x86_64
yum -y install gdb.x86_64

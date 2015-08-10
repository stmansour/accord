wget64 -O cygwin-setup.exe --user accord --password AP4GxDHU2f6EriLqry781wG6fy http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils/cygwin-setup.exe
wget64 -O getcygwin.bat --user accord --password AP4GxDHU2f6EriLqry781wG6fy http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils/getcygwin.bat
wget64 -O setup-win-jenkins --user accord --password AP4GxDHU2f6EriLqry781wG6fy http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils/setup-win-jenkins
call getcygwin.bat
copy setup-win-jenkins c:\cygwin\home\Administrator
c:\cygwin\bin\bash -i --login setup-win-jenkins

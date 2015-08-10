REM
REM  -- Windows Jenkins Setup script
REM

SETLOCAL


REM
REM  -- Download some of the basic stuff we need to get started.
REM
wget64 -O cygwin-setup.exe --user accord --password AP4GxDHU2f6EriLqry781wG6fy http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils/cygwin-setup.exe
wget64 -O getcygwin.bat --user accord --password AP4GxDHU2f6EriLqry781wG6fy http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils/getcygwin.bat
wget64 -O setup-win-jenkins --user accord --password AP4GxDHU2f6EriLqry781wG6fy http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils/setup-win-jenkins
call getcygwin.bat

REM
REM  -- Force Administrator home directory to be created
REM
c:\cygwin\bin\bash -l -c pwd

REM
REM  -- copy the script we need to execut in the bash shell to 
REM  -- Adminstrator's home directory
REM
copy setup-win-jenkins c:\cygwin\home\Administrator

REM
REM  -- Now we let the bash shell script take over...
REM
c:\cygwin\bin\bash -l setup-win-jenkins


ENDLOCAL

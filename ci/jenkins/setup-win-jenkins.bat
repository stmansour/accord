echo off
REM
REM  -- Windows Jenkins Setup script
REM

REM
REM  -- Start off by creating the directory where we can put the tools
REM  -- we need for Jenkins.
REM
SET USR=accord
SET PASS=AP4GxDHU2f6EriLqry781wG6fy
SET ART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils
SET JART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/java
SET INSTALLHOME=C:\Users\Administrator\Downloads
SET ACCORD_ROOT=C:\Program Files
SET ACCORD_DNAME=Accord
SET ACCORD_HOME=%ACCORD_ROOT%\%ACCORD_DNAME%
SET WGET=wget64.exe
SET UNZIP=unzip.exe



ECHO Creating c:\Windows\Accord with unix tools
PUSHD %ACCORD_ROOT%
    MKDIR %ACCORD_DNAME%
    MKDIR %ACCORD_DNAME%\bin
    SETX /M Path "%PATH%;%ACCORD_HOME%\bin"
    SET PATH=%PATH%;%ACCORD_HOME%\bin
    ECHO C:\Program Files\Accord\bin added to the path
POPD
COPY wget64.exe %ACCORD_HOME%\bin

REM  -- It does not make sense to perform these at this time
REM  -- but this bat script starts failing setx commands at 
REM  -- some point. Haven't figured out what's causing it.
REM  -- The workaround is to do this stuff up front before
REM  -- we've actually downloaded and installed these files
SETX /M GRADLE_HOME "%ACCORD_HOME%\gradle-2.6"
SET GRADLE_HOME="%ACCORD_HOME%\gradle-2.6"
SETX /M Path "%PATH%;%GRADLE_HOME%\bin"
SET PATH=%PATH%;%GRADLE_HOME%\bin


REM
REM  -- Download the artifacts we need
REM
CALL :SUB_WGET java            jdk-8u51-windows-x64.exe
CALL :SUB_WGET ext-tools/utils cygwin-setup.exe
CALL :SUB_WGET ext-tools/utils getcygwin.bat
CALL :SUB_WGET ext-tools/utils setup-win-jenkins.sh
CALL :SUB_WGET ext-tools/utils Git-1.9.5-preview20150319.exe
CALL :SUB_WGET ext-tools/utils gradle-2.6-bin.zip
CALL :SUB_WGET ext-tools/utils jenkins-1.624.zip
CALL :SUB_WGET ext-tools/utils %UNZIP%

copy unzip.exe "C:\Program Files\Accord\bin"
copy gradle-2.6-bin.zip "%ACCORD_HOME%"
PUSHD "%ACCORD_HOME%"
    unzip.exe gradle-2.6-bin.zip
POPD

REM check to see if path works while downloading git

REM
REM  -- Install cygwin
REM  -- Force Administrator home directory to be created 
REM  -- copy the script there...
REM
call getcygwin.bat
c:\cygwin\bin\bash -l -c pwd
copy setup-win-jenkins.sh c:\cygwin\home\Administrator
c:\cygwin\bin\bash -l setup-win-jenkins.sh

REM
REM  -- jenkins.msi should now be in c:\cygwin\home\Administrator
REM

echo Installing JENKINS...
call c:\Windows\System32\msiexec.exe /i jenkins.msi /qn /l*vx jenkins.log
echo Completed JENKINS installation!
echo Please allow a couple of minutes for jenkins to start up

GOTO :EOF

REM ###########################################################################

:SUB_WGET
    ECHO Downloading %~1/%~2
    %WGET% -O %~2 --user %USR% --password %PASS% %ART%/%~1/%~2
    EXIT /B

:EOF

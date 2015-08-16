@echo off
REM
REM  -- Windows Jenkins Setup script
REM

REM
REM  -- Start off by creating the directory where we can put the tools
REM  -- we need for Jenkins.
REM
SET USR=accord
SET PASS=AP4GxDHU2f6EriLqry781wG6fy
SET ART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory
SET INSTALLHOME=C:\Users\Administrator\Downloads
SET ACCORD_ROOT=C:\Program Files
SET ACCORD_DNAME=Accord
SET ACCORD_HOME=%ACCORD_ROOT%\%ACCORD_DNAME%
SET WGET=wget64.exe
SET UNZIP=unzip.exe
SET UNZIPCMD=7z e

ECHO Creating c:\Windows\Accord with unix tools
PUSHD %ACCORD_ROOT%
    MKDIR %ACCORD_DNAME%
    MKDIR %ACCORD_DNAME%\bin
    SETX /M Path "%ACCORD_HOME%\bin;%PATH%"
    SET PATH=%ACCORD_HOME%\bin;%PATH%
    ECHO C:\Program Files\Accord\bin added to the path
POPD
COPY wget64.exe "%ACCORD_HOME%\bin"

REM  -- It does not make sense to perform these at this time
REM  -- but this bat script starts failing setx commands at 
REM  -- some point. Haven't figured out what's causing it.
REM  -- The workaround is to do this stuff up front before
REM  -- we've actually downloaded and installed these files
SETX /M JAVA_HOME "C:\Program Files\Java\jdk1.8.0_51"
SET JAVA_HOME=C:\Program Files\Java\jdk1.8.0_51
SETX /M Path "C:\Program Files\Java\jdk1.8.0_51\bin;%PATH%"
SET PATH="C:\Program Files\Java\jdk1.8.0_51\bin;%PATH%"
SETX /M GRADLE_HOME "%ACCORD_HOME%\gradle-2.6"
SET GRADLE_HOME=%ACCORD_HOME%\gradle-2.6
SETX /M Path "%GRADLE_HOME%\bin;%PATH%"
SET PATH=%GRADLE_HOME%\bin;%PATH%


REM
REM  -- Download the artifacts we need
REM
CALL :SUB_WGET ext-tools/java  jdk-8u51-windows-x64.exe
CALL :SUB_WGET ext-tools/utils cygwin-setup.exe
CALL :SUB_WGET ext-tools/utils getcygwin.bat
CALL :SUB_WGET ext-tools/utils Git-1.9.5-preview20150319.exe
CALL :SUB_WGET ext-tools/utils gradle-2.6.tar
CALL :SUB_WGET ext-tools/utils jenkins-1.624.zip
CALL :SUB_WGET ext-tools/utils 7z.tar
CALL :SUB_WGET ext-tools/utils ottoaccord.tar.gz

REM
REM  -- Install cygwin
REM
call getcygwin.bat

REM
REM  -- install Java
REM
ECHO "Starting jdk installation..."
jdk-8u51-windows-x64.exe /s
ECHO "installation complete"

REM
REM  -- install gradle
REM
echo INSTALL GRADLE...
copy gradle-2.6.tar "%ACCORD_HOME%"
copy 7z.tar "%ACCORD_HOME%"
PUSHD "%ACCORD_HOME%"
    cd bin
    c:\cygwin\bin\tar.exe xvf ../7z.tar
    cd ..
    c:\cygwin\bin\tar.exe xvf gradle-2.6.tar
    del gradle-2.6.tar 7z.tar
POPD
echo GRADLE INSTALLATION COMPLETE
echo Current directory = %CD%

REM
REM  -- install jenkins
REM
echo Uncompressing JENKINS...
"c:\Program Files\Accord\bin\7z" e jenkins-1.624.zip
echo Installing JENKINS...
call c:\Windows\System32\msiexec.exe /i jenkins.msi /qn /l*vx jenkins.log
echo Completed JENKINS installation!
echo Please allow a couple of minutes for jenkins to start up

GOTO :EOF

REM ###########################################################################

:SUB_WGET
    ECHO DOWNLOADING %~1/%~2
    %WGET% -O %~2 --user %USR% --password %PASS% %ART%/%~1/%~2
    EXIT /B

:EOF

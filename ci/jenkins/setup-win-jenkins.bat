@echo off
REM
REM  -- Windows Jenkins Setup script
REM  -- Sets up a Jenkins instance for Accord based on Amazon's
REM  -- base system for Windows Server 2012
REM

REM
REM  -- Set the versions of software that we'll download
REM
SET JDKVER=jdk1.8.0_51
SET JAVAINSTALLER=jdk-8u51-windows-x64.exe
SET GRADLEVER=gradle-2.6
SET JENKINSVER=jenkins-1.624

REM
REM  -- Start off by creating the directory where we can put the tools
REM  -- we need for Jenkins.
REM
SET USR=accord
SET PASS=AP4GxDHU2f6EriLqry781wG6fy
SET ART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory
SET INSTALLHOME=C:\Users\Administrator\Downloads
SET ACCORD_HOME=C:\Accord
SET WGET=wget64.exe
SET STX=C:\Windows\System32\SETX.exe

ECHO Creating c:\Windows\Accord with unix tools
MKDIR %ACCORD_HOME%
MKDIR %ACCORD_HOME%\bin
COPY wget64.exe %ACCORD_HOME%\bin

echo JAVA
SET JAVA_HOME=C:\Program Files\Java\%JDKVER%
%STX% /M JAVA_HOME "C:\Program Files\Java\%JDKVER%"
SET PATH=%JAVA_HOME%\bin;%PATH%

echo GRADLE
SET GRADLE_HOME=%ACCORD_HOME%\gradle
%STX% /M GRADLE_HOME "%ACCORD_HOME%\gradle"
SET PATH=%GRADLE_HOME%\bin;%PATH%

echo ACCORD
SET PATH=%ACCORD_HOME%\bin;%PATH%

REM  -- after a few 'setx /m Path' commands, the system
REM  -- becomes unstable and the Path environment variable
REM  -- has bad/incomplete values. Haven't figured this out yet.
REM  -- for now, minimize the setx calls
REM %STX% /M Path "%ACCORD_HOME%\bin;%PATH%"
REM %STX% /M Path "%JAVA_HOME%\bin;%PATH%"
REM %STX% /M Path "%GRADLE_HOME%\bin;%PATH%"

REM  -- until the quoting problem is nailed, this seems to work...
SETX /M Path "C:\Program Files\Java\%JDKVER%\bin;c:\Accord\Git\cmd;c:\Accord\Git\bin;c:\Accord\Git\bin;c:\Accord\gradle\bin;c:\Accord\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\Amazon\cfn-bootstrap"


REM
REM  -- Download the artifacts we need
REM
CALL :SUB_WGET ext-tools/java  %JAVAINSTALLER%
CALL :SUB_WGET ext-tools/utils cygwin-setup.exe
CALL :SUB_WGET ext-tools/utils getcygwin.bat
CALL :SUB_WGET ext-tools/utils Git.tar.zip
CALL :SUB_WGET ext-tools/utils %GRADLEVER%.tar
CALL :SUB_WGET ext-tools/utils %JENKINSVER%.zip
CALL :SUB_WGET ext-tools/utils 7z.tar
CALL :SUB_WGET ext-tools/utils ottoaccord.tar.gz
CALL :SUB_WGET ext-tools/utils deployfile.sh
CALL :SUB_WGET ext-tools/utils jenkins-linux-config.tar

REM
REM  -- Install cygwin
REM
CALL getcygwin.bat

REM
REM  -- Install Java
REM
ECHO "Starting jdk installation..."
%JAVAINSTALLER% /s
ECHO "installation complete"

REM
REM  -- Install git and gradle
REM
ECHO INSTALL GIT and GRADLE...
COPY %GRADLEVER%.tar "%ACCORD_HOME%"
COPY Git.tar.zip "%ACCORD_HOME%"
COPY 7z.tar "%ACCORD_HOME%"
PUSHD "%ACCORD_HOME%"
    CD bin
    c:\cygwin\bin\tar.exe xvf ../7z.tar
    CD ..
    .\bin\7z e Git.tar.zip
    c:\cygwin\bin\tar.exe xvf Git.tar
    c:\cygwin\bin\tar.exe xvf %GRADLEVER%.tar
    DEL %GRADLEVER%.tar 7z.tar Git.ta*
POPD
ECHO GIT and GRADLE INSTALLATION COMPLETE
ECHO Current directory = %CD%

REM
REM  -- add credentials
REM
ECHO Installing credentials for Jenkins to use with GitHub
COPY ottoaccord.tar.gz C:\Windows\SysWOW64\config\systemprofile
PUSHD C:\Windows\SysWOW64\config\systemprofile
    ECHO DIR before tar
    REM - tar not working here during. ???
    REM out of desperation, try 7z.exe too.  Tar will overwrite if it works
    %ACCORD_HOME%\bin\7z.exe x ottoaccord.tar
    DIR
    c:\cygwin\bin\tar.exe xvf ottoaccord.tar
    ECHO DIR after tar
    DIR
POPD

REM
REM  -- install jenkins
REM
ECHO Uncompressing JENKINS...
%ACCORD_HOME%\bin\7z e %JENKINSVER%.zip
ECHO Installing JENKINS...
CALL c:\Windows\System32\msiexec.exe /i jenkins.msi /qn /l*vx jenkins.log

copy jenkins-linux-config.tar "C:\Program Files (x86)\Jenkins"
PUSHD "C:\Program Files (x86)\Jenkins"
timeout /t 30
ECHO Directory before tar...
DIR
REM - tar not working here during. ???
REM out of desperation, try 7z.exe too.  Tar will overwrite if it works
%ACCORD_HOME%\bin\7z.exe x jenkins-linux-config.tar
ECHO Untarring the jenkins saved configuration
c:\cygwin\bin\tar.exe xvf jenkins-linux-config.tar
ECHO Directory after tar...
DIR
ECHO Restarting Jenkins...
.\jenkins.exe restart
timeout /t 10
POPD
ECHO Completed JENKINS installation!

copy deployfile.sh  %ACCORD_HOME%\bin
c:\cygwin\bin\chmod.exe +x /cygdrive/c/Accord/bin/deployfile.sh

GOTO :EOF

REM ###########################################################################

:SUB_WGET
    ECHO DOWNLOADING %~1/%~2
    %WGET% -O %~2 --user %USR% --password %PASS% %ART%/%~1/%~2
    EXIT /B

:EOF

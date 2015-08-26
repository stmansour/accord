@echo off
REM  ---------------------------------------------------------------
REM  -- Windows Jenkins Setup script
REM  -- Sets up a Jenkins instance for Accord based on Amazon's
REM  -- base system for Windows Server 2012
REM  -- Version 1.0
REM  --    sman@stevemansour.com
REM  ---------------------------------------------------------------

REM  ---------------------------------------------------------------
REM  -- Set the versions of software that we'll download and use
REM  ---------------------------------------------------------------
SET JDKVER=jdk1.8.0_51
SET JAVAINSTALLER=jdk-8u51-windows-x64.exe
SET GRADLEVER=gradle-2.6
SET JENKINSVER=jenkins-1.624
SET JENKINSCONFIGTAR=jenkins-win-config.tar
SET WGET=wget64.exe
SET STX=C:\Windows\System32\SETX.exe
SET LOGFILE C:\Users\Administrator\Downloads\win-jenk-install-log.txt

REM  ---------------------------------------------------------------
REM  -- These are the credentials we'll need to access the 
REM  -- Artifactory repository...
REM  ---------------------------------------------------------------
SET USR=accord
SET PASS=AP4GxDHU2f6EriLqry781wG6fy
SET ART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory

REM  ---------------------------------------------------------------
REM  -- Start off by creating the directory where we can put the tools
REM  -- we need for Jenkins.
REM  ---------------------------------------------------------------
SET INSTALLHOME=C:\Users\Administrator\Downloads
SET ACCORD_HOME=C:\Accord
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

REM  ---------------------------------------------------------------
REM  -- after a few 'setx /m Path' commands, the system
REM  -- becomes unstable and the Path environment variable
REM  -- has bad/incomplete values. Haven't figured this out yet.
REM  -- for now, minimize the setx calls
REM  ---------------------------------------------------------------
REM %STX% /M Path "%ACCORD_HOME%\bin;%PATH%"
REM %STX% /M Path "%JAVA_HOME%\bin;%PATH%"
REM %STX% /M Path "%GRADLE_HOME%\bin;%PATH%"

REM  ---------------------------------------------------------------
REM  -- until the quoting problem is nailed, this seems to work...
REM  ---------------------------------------------------------------
SETX /M Path "C:\Program Files\Java\%JDKVER%\bin;c:\Accord\Git\cmd;c:\Accord\Git\bin;c:\Accord\Git\bin;c:\Accord\gradle\bin;c:\Accord\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\Amazon\cfn-bootstrap"


REM  ---------------------------------------------------------------
REM  -- Download the artifacts we need
REM  ---------------------------------------------------------------
CALL :SUB_WGET ext-tools/java  %JAVAINSTALLER%
CALL :SUB_WGET ext-tools/utils cygwin-setup.exe
CALL :SUB_WGET ext-tools/utils getcygwin.bat
CALL :SUB_WGET ext-tools/utils Git.tar.zip
CALL :SUB_WGET ext-tools/utils %GRADLEVER%.tar
CALL :SUB_WGET ext-tools/utils %JENKINSVER%.zip
CALL :SUB_WGET ext-tools/utils 7z.tar
CALL :SUB_WGET ext-tools/utils ottoaccord.tar
CALL :SUB_WGET ext-tools/utils deployfile.sh
CALL :SUB_WGET ext-tools/utils %JENKINSCONFIGTAR%
CALL :SUB_WGET ext-tools/utils jenkins-win-archiver.sh

REM  ---------------------------------------------------------------
REM  -- begin to build out the accord-specific tool directory
REM  ---------------------------------------------------------------
COPY deployfile.sh  %ACCORD_HOME%\bin
COPY jenkins-win-archiver.sh  %ACCORD_HOME%\bin
c:\cygwin\bin\chmod.exe +x /cygdrive/c/Accord/bin/deployfile.sh

REM  ---------------------------------------------------------------
REM  -- Install cygwin.  For this installation script, I think we
REM  -- only need tar.exe.  But if we need to log into the machine
REM  -- to do any poking around / debugging, having this suite of 
REM  -- tools there when you need them is a life-saver.  Not only
REM  -- are the tools there, but the man pages are there too!
REM  ---------------------------------------------------------------
CALL getcygwin.bat

REM  ---------------------------------------------------------------
REM  -- Install Java
REM  ---------------------------------------------------------------
ECHO "Starting jdk installation..."
%JAVAINSTALLER% /s
ECHO "installation complete"

REM  ---------------------------------------------------------------
REM  -- Install git and gradle
REM  ---------------------------------------------------------------
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

REM  ---------------------------------------------------------------
REM  -- add credentials.  The idea here is that for any work being
REM  -- done in Accord, our virtual build entity, Otto Accord, will
REM  -- do the builds and manage the artifactory versions. So, all
REM  -- projects will need to make Otto a contributor in GitHub.
REM  ---------------------------------------------------------------
ECHO Installing credentials for Jenkins to use with GitHub
COPY ottoaccord.tar C:\Windows\SysWOW64\config\systemprofile
PUSHD C:\Windows\SysWOW64\config\systemprofile
    ECHO DIR before tar
    REM  ---------------------------------------------------------------
    REM  -- tar not working here during. ???
    REM  -- out of desperation, try 7z.exe too.  Tar will overwrite
    REM  -- assuming it works...
    REM  ---------------------------------------------------------------
    %ACCORD_HOME%\bin\7z.exe x ottoaccord.tar -y
    DIR
    c:\cygwin\bin\tar.exe xvf ottoaccord.tar
    ECHO DIR after tar
    DIR
POPD

REM  ---------------------------------------------------------------
REM  -- install jenkins
REM  ---------------------------------------------------------------
ECHO Uncompressing JENKINS...
%ACCORD_HOME%\bin\7z e %JENKINSVER%.zip
ECHO Installing JENKINS...
CALL c:\Windows\System32\msiexec.exe /i jenkins.msi /qn /l*vx jenkins.log
COPY %JENKINSCONFIGTAR% "C:\Program Files (x86)\Jenkins"
PUSHD "C:\Program Files (x86)\Jenkins"
    REM  ---------------------------------------------------------------
    REM  The installer automatically starts Jenkins (even though we
    REM  really wanted it not to start yet). We'll need to let it start
    REM  up all the way, then stop it before setting the configuration
    REM  the way we want it.
    REM  ---------------------------------------------------------------
    timeout /t 30

    REM  ---------------------------------------------------------------
    REM  OK, it's had enough time to start up.  Now, let's kill it
    REM  and install our configuration.
    REM  ---------------------------------------------------------------
    .\jenkins.exe stop
    timout /t 5
    ECHO Use 7z to untar the configuration
    %ACCORD_HOME%\bin\7z.exe x %JENKINSCONFIGTAR% -y
    ECHO Untarring the jenkins saved configuration
    c:\cygwin\bin\tar.exe xvf %JENKINSCONFIGTAR%
    ECHO Restarting Jenkins...
    .\jenkins.exe start
    timeout /t 10
POPD
ECHO Completed JENKINS installation!


GOTO :EOF

REM ################################################################
REM  ---------------------------------------------------------------
REM  --  A subroutine to pull files from Artifactory
REM  ---------------------------------------------------------------
:SUB_WGET
    ECHO DOWNLOADING %~1/%~2
    %WGET% -O %~2 --user %USR% --password %PASS% %ART%/%~1/%~2
    EXIT /B

:EOF

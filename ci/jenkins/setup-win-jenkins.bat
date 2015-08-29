@echo off
REM  ---------------------------------------------------------------
REM  -- Windows Jenkins Setup script
REM  -- Sets up a Jenkins instance for Accord based on Amazon's
REM  -- base system for Windows Server 2012
REM  -- All necessary files have been downloaded by the powershell
REM  -- script and can be found in c:\Users\Administrator\Downloads
REM  --
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
SET JENKINSCONFIGTAR=jnk-win-conf.tar
SET JENKINSJOBTAR=jnk-win-job.tar
SET WGET=wget64.exe
SET STX=C:\Windows\System32\SETX.exe
SET LOGFILE=C:\Users\Administrator\Downloads\win-jenk-install-log.txt

ECHO *** BEGIN - INSTALL WINDOWS JENKINS CONFIGURATION **  >%LOGFILE%
DATE /t >>%LOGFILE%
TIME /t >>%LOGFILE%

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
ECHO Creating c:\Windows\Accord with unix tools >>%LOGFILE%
MKDIR %ACCORD_HOME%
MKDIR %ACCORD_HOME%\bin
COPY wget64.exe %ACCORD_HOME%\bin

echo JAVA >>%LOGFILE%
SET JAVA_HOME=C:\Program Files\Java\%JDKVER%
%STX% /M JAVA_HOME "C:\Program Files\Java\%JDKVER%"
SET PATH=%JAVA_HOME%\bin;%PATH%

echo GRADLE >>%LOGFILE%
SET GRADLE_HOME=%ACCORD_HOME%\gradle
%STX% /M GRADLE_HOME "%ACCORD_HOME%\gradle"
SET PATH=%GRADLE_HOME%\bin;%PATH%

echo ACCORD >>%LOGFILE%
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
REM  -- begin to build out the accord-specific tool directory
REM  ---------------------------------------------------------------
ECHO Copying tools to  %ACCORD_HOME%\bin  >>%LOGFILE%
COPY *.sh  %ACCORD_HOME%\bin\
COPY jenkins-win-archiver.sh  %ACCORD_HOME%\bin
c:\cygwin\bin\chmod.exe +x /cygdrive/c/Accord/bin/*.sh

REM  ---------------------------------------------------------------
REM  -- Install cygwin.  For this installation script, I think we
REM  -- only need tar.exe.  But if we need to log into the machine
REM  -- to do any poking around / debugging, having this suite of 
REM  -- tools there when you need them is a life-saver.  Not only
REM  -- are the tools there, but the man pages are there too!
REM  ---------------------------------------------------------------
ECHO Installing cygwin >>%LOGFILE%
CALL getcygwin.bat
ECHO cygwin installation complete >>%LOGFILE%
DATE /t >>%LOGFILE%
TIME /t >>%LOGFILE%

REM  ---------------------------------------------------------------
REM  -- Install Java
REM  ---------------------------------------------------------------
ECHO "Starting JDK installation..." >>%LOGFILE%
%JAVAINSTALLER% /s
ECHO "JDK installation complete" >>%LOGFILE%

REM  ---------------------------------------------------------------
REM  -- Install git and gradle
REM  ---------------------------------------------------------------
ECHO INSTALL GIT and GRADLE... >>%LOGFILE%
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
ECHO GIT and GRADLE INSTALLATION COMPLETE  >>%LOGFILE%
ECHO Current directory = %CD%  >>%LOGFILE%

REM  ---------------------------------------------------------------
REM  -- add credentials.  The idea here is that for any work being
REM  -- done in Accord, our virtual build entity, Otto Accord, will
REM  -- do the builds and manage the artifactory versions. So, all
REM  -- projects will need to make Otto a contributor in GitHub.
REM  ---------------------------------------------------------------
ECHO Installing credentials for Jenkins to use with GitHub >>%LOGFILE%
COPY ottoaccord.tar C:\Windows\SysWOW64\config\systemprofile
PUSHD C:\Windows\SysWOW64\config\systemprofile
    ECHO DIR before tar >>%LOGFILE%
    REM  ---------------------------------------------------------------
    REM  -- tar not working here during. ???
    REM  -- out of desperation, try 7z.exe too.  Tar will overwrite
    REM  -- assuming it works...
    REM  ---------------------------------------------------------------
    %ACCORD_HOME%\bin\7z.exe x ottoaccord.tar -y
    DIR >>%LOGFILE%
    c:\cygwin\bin\tar.exe xvf ottoaccord.tar
    ECHO DIR after tar >>%LOGFILE%
    DIR >>%LOGFILE%
POPD

REM  ---------------------------------------------------------------
REM  -- install jenkins
REM  ---------------------------------------------------------------
ECHO Uncompressing JENKINS...
%ACCORD_HOME%\bin\7z e %JENKINSVER%.zip
ECHO Installing JENKINS... >>%LOGFILE%
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
    ECHO Use 7z to untar the configuration >>%LOGFILE%
    %ACCORD_HOME%\bin\7z.exe x %JENKINSCONFIGTAR% -y

    REM  ---------------------------------------------------------------
    REM  --  Now install the jobs
    REM  ---------------------------------------------------------------
    ECHO Use 7z to untar the jobs  >>%LOGFILE%
    cd .\jobs
    COPY "C:\Users\Administrator\Downloads\%JENKINSJOBTAR%" .
    %ACCORD_HOME%\bin\7z.exe x %JENKINSJOBTAR% -y
    cd ..

    REM  ---------------------------------------------------------------
    REM  --  All done. Now restart jenkins
    REM  ---------------------------------------------------------------
    ECHO Restarting Jenkins... >>%LOGFILE%
    .\jenkins.exe start
    timeout /t 10
POPD

ECHO Completed JENKINS installation! >>%LOGFILE%

REM  ---------------------------------------------------------------
REM  -- Create a symbolic link so that /c maps to /cygdrive/c 
REM  -- This makes file access for the unix tools the same
REM  -- whether we use the cygwin tools or the tools that come with
REM  -- the windows version of GIT
REM  ---------------------------------------------------------------
C:\cygwin\bin\bash.exe -l -c "ln -s /cygdrive/c /c"

REM  ---------------------------------------------------------------
REM  -- OK, that's it. The system should be ready for use now.
REM  ---------------------------------------------------------------

DATE /t >>%LOGFILE%
TIME /t >>%LOGFILE%
ECHO *** END - INSTALL WINDOWS JENKINS CONFIGURATION **  >>%LOGFILE%

:EOF

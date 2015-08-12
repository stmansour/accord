ECHO off
REM
REM  -- Windows Jenkins Setup script
REM

SETLOCAL

SET USR=accord
SET PASS=AP4GxDHU2f6EriLqry781wG6fy
SET ART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils
SET JART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/java
SET WGET=wget64.exe
SET INSTALLHOME="C:\Users\Administrator\Downloads"
SET ACCORDBIN="C:\Program Files\Accord"

REM
REM  -- Start off by creating the directory where we can put the tools
REM  -- we need for Jenkins.
REM
ECHO Creating c:\Windows\Accord with unix tools
CD "C:\Program Files"
MKDIR "Accord"
SETX /M Path "%PATH%;%ACCORDBIN%"
SET PATH="%PATH%;%ACCORDBIN%"
ECHO C:\Program Files\Accord added to the path
CD "%INSTALLHOME"

REM
REM  -- Download some of the basic stuff we need to get started.
REM
CALL :SUB_WGETJAVA jdk-8u51-windows-x64.exe
CALL :SUB_WGET cygwin-setup.exe
CALL :SUB_WGET getcygwin.bat
CALL :SUB_WGET setup-win-jenkins
CALL :SUB_WGET Git-1.9.5-preview20150319.exe
CALL :SUB_WGET jenkins-1.624.zip
CALL :SUB_WGET unzip.exe

REM
REM  -- Now that we have a location for these tools and the path is updated,
REM  -- put wget64.exe in the tools directory. We'll use it a lot
REM
COPY wget64.exe "%ACCORDBIN%"
COPY unzip.exe "%ACCORDBIN%"

REM Here's a note straight from the Jenkins Installation guide:
REM    Since Jenkins was written to work on unix-like platforms, some parts
REM    assume the presence of unix-utilities. It is advised to install these as
REM    well on Windows. Install UnxUtils (this includes a shell that seems to work
REM    with forward and backwards slashes and does globbing correctly)(UnxUtils
REM    does not download), put it in the Windows PATH , and copy sh.exe to
REM    C:\bin\sh.exe (or whichever drive you use) to make shebang lines work.
REM    This should get you going.
REM
REM OK, so based on this we'll download and install UnxUtils.  These look like
REM a subset of the Cygwin code, but they run as native windows apps using MSCRT.DLL
REM rather than Cygwin's emulation layer.

CALL :SUB_WGET UnxUpdates.zip

ECHO Extracting tools to c:\windows\accord
CD  "%ACCORDBIN%"
unzip "%INSTALLHOME%\UnxUpdates.zip"
CD "%INSTALLHOME%"

REM
REM  -- Install cygwin
REM

CALL getcygwin.bat

REM
REM ensure that the windows system environment variables for JAVA
REM are set up properly and that the default PATH will find the
REM java programs
REM

ECHO "Setting System environment variables JAVA_HOME and PATH..."
ECHO "Updating global path to include C:\\Program Files\\Java\\jdk1.8.0_51\\bin"
ECHO "use the SETX command which needs to run from a command prompt"
SETX /M JAVA_HOME "C:\Program Files\Java\jdk1.8.0_51"
SETX /M Path "%PATH%;C:\Program Files\Java\jdk1.8.0_51\bin"
SET JAVA_HOME="C:\Program Files\Java\jdk1.8.0_51"
SET Path="%PATH%;C:\Program Files\Java\jdk1.8.0_51\bin"

REM
REM  -- jenkins.msi should now be in c:\cygwin\home\Administrator
REM

ECHO Installing JENKINS...
unzip jenkins-1.624.zip
CALL c:\Windows\System32\msiexec.exe /i jenkins.msi /qn /l*vx jenkins.log
ECHO Completed JENKINS installation!
ECHO Please allow a couple of minutes for jenkins to start up

GOTO :EOF

REM ###########################################################################

:SUB_WGET
    ECHO Downloading %~1
    %WGET% -O %~1 --user %USR% --password %PASS% %ART%/%~1
    EXIT /B

:SUB_WGETJAVA
    ECHO Downloading %~1
    %WGET% -O %~1 --user %USR% --password %PASS% %JART%/%~1
    EXIT /B


:EOF

ENDLOCAL

echo off
REM
REM  -- Windows Jenkins Setup script
REM

SETLOCAL

SET USR=accord
SET PASS=AP4GxDHU2f6EriLqry781wG6fy
SET ART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils
SET JART=http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/java
set WGET=wget64.exe

REM
REM  -- Start off by creating the directory where we can put the tools
REM  -- we need for Jenkins.
REM
echo Creating c:\Windows\Accord with unix tools
pushd "C:\Program Files"
    mkdir "Accord"
    setx /M Path "%PATH%;C:\Program Files\Accord"
    set PATH="%PATH%;C:\Program Files\Accord"
    echo C:\Program Files\Accord added to the path
popd

REM
REM  -- Now that we have a location for these tools and the path is updated,
REM  -- put wget64.exe in the tools directory. We'll use it a lot
REM

copy wget64.exe "C:\Program Files\Accord"

REM
REM  -- Download some of the basic stuff we need to get started.
REM
CALL :SUB_WGET cygwin-setup.exe
CALL :SUB_WGET getcygwin.bat
CALL :SUB_WGET setup-win-jenkins
CALL :SUB_WGET Git-1.9.5-preview20150319.exe

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
REM  -- a bug in cygwin shells causes it to truncate lines after about 153 chars
REM  -- So, the wget or curl commands end up truncating and failing.
REM  -- We'll use good ole wget64 to pull down what we need...
REM

pushd c:\cygwin\home\Administrator
    CALL :SUB_WGETJAVA jdk-8u51-windows-x64.exe
    CALL :SUB_WGET jdk-8u51-windows-x64.exe
    CALL :SUB_WGET jenkins-1.624.zip
    CALL :SUB_WGET unzip.exe
    copy unzip.exe "C:\Program Files\Accord"

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

    REM
    REM  -- Create a directory for the unix tools, add it to the Windows path
    REM

    echo Extracting tools to c:\windows\accord
    cd "C:\Program Files\Accord"
    unzip c:\cygwin\home\Administrator\UnxUpdates.zip

popd

REM
REM  -- Now we let the bash shell script take over...
REM

c:\cygwin\bin\bash -l setup-win-jenkins

REM
REM  -- jenkins.msi should now be in c:\cygwin\home\Administrator
REM

pushd c:\cygwin\home\Administrator
    echo Installing JENKINS...
    unzip jenkins-1.624.zip
    call c:\Windows\System32\msiexec.exe /i jenkins.msi /qn /l*vx jenkins.log
    echo Completed JENKINS installation!
    echo Please allow a couple of minutes for jenkins to start up
popd

GOTO :EOF

REM ###########################################################################

:SUB_WGET
    echo Downloading %~1
    %WGET% -O %~1 --user %USR% --password %PASS% %ART%/%~1
    EXIT /B

:SUB_WGETJAVA
    echo Downloading %~1
    %WGET% -O %~1 --user %USR% --password %PASS% %JART%/%~1
    EXIT /B


:EOF

ENDLOCAL

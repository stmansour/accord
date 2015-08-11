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
REM  -- a bug in cygwin shells causes it to truncate lines after about 153 chars
REM  -- So, the wget or curl commands end up truncating and failing.
REM  -- We'll use good ole wget64 to pull down what we need...
REM

pushd c:\cygwin\home\Administrator
C:\Users\Administrator\Downloads\wget64.exe -O unzip.exe --user accord --password AP4GxDHU2f6EriLqry781wG6fy http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils/unzip.exe
copy unzip.exe c:\windows\system32

C:\Users\Administrator\Downloads\wget64.exe -O jdk-8u51-windows-x64.exe --user accord --password AP4GxDHU2f6EriLqry781wG6fy http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/java/jdk-8u51-windows-x64.exe
C:\Users\Administrator\Downloads\wget64.exe -O jenkins-1.624.zip --user accord --password AP4GxDHU2f6EriLqry781wG6fy http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils/jenkins-1.624.zip

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
C:\Users\Administrator\Downloads\wget64.exe -O UnxUpdates.zip --user accord --password AP4GxDHU2f6EriLqry781wG6fy http://ec2-52-6-164-191.compute-1.amazonaws.com/artifactory/ext-tools/utils/UnxUpdates.zip

REM  -- Make sure they're in the normal Windows path
cd c:\Windows\System32
unzip c:\cygwin\home\Administrator\UnxUpdates.zip

popd

REM
REM  -- Now we let the bash shell script take over...
REM
c:\cygwin\bin\bash -l setup-win-jenkins

REM
REM  -- jenkins.msi should now be in c:\cygwin\home\Administrator
REM
echo "Installing JENKINS..."
call msiexec /i c:\cygwin\home\Adminstrator\jenkins.msi /qn /l*v jenkins.log JENKINSDIR="C:\jenkins"
echo "Completed JENKINS installation!"
echo "Please allow a couple of minutes for jenkins to start up"

ENDLOCAL

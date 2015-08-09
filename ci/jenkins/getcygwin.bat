REM @ECHO OFF
REM -- Automates cygwin installation

SETLOCAL

REM -- Change to the directory of the executing batch file
CD %HOMEPATH%/Downloads

REM -- Configure our paths
SET SITE=http://box-soft.com
SET LOCALDIR=%CD%
SET ROOTDIR=C:/cygwin

REM -- These are the packages we will install (in addition to the default packages)
SET PACKAGES=wget,git,curl
REM SET PACKAGES=%PACKAGES%,gcc4,make,automake,autoconf,readline,libncursesw-devel,
REM SET PACKAGES=%PACKAGES%,lua,python,ruby

REM -- Do it!
ECHO *** INSTALLING DEFAULT PACKAGES
cygwin-setup -q -d -D -L -X -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%"
ECHO.
ECHO.
ECHO *** INSTALLING CUSTOM PACKAGES
cygwin-setup -q -d -D -L -X -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%" -P %PACKAGES%

REM -- Show what we did
ECHO.
ECHO.
ECHO cygwin installation updated
ECHO  - %PACKAGES%
ECHO.

ENDLOCAL

REM EXIT /B 0

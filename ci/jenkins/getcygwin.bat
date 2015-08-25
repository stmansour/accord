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
SET PACKAGES=wget,git,curl,unzip

REM -- Do it!
ECHO *** INSTALLING CUSTOM PACKAGES
cygwin-setup.exe -q -d -D -L -X -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%" -P %PACKAGES%

REM -- Show what we did
ECHO.
ECHO.
ECHO cygwin installation updated
ECHO  - %PACKAGES%
ECHO.

ENDLOCAL

EXIT /B 0

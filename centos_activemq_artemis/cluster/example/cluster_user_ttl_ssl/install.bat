@echo off
cd /d %~dp0

copy /y etc\* broker1\etc\
copy /y etc\* broker2\etc\
copy /y etc\* broker3\etc\

pause

@echo off

REM Set the OpenShift Project to use
set PROJECT=

REM Create the Build Config
oc new-build --strategy docker --binary --docker-image centos:centos7 --name shellbox -n %PROJECT%

REM Start the Build
oc start-build shellbox --from-dir . --follow -n %PROJECT%

REM Deploy the Application
oc new-app shellbox --name shellbox -n %PROJECT%

echo.
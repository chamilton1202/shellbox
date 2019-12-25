#!/bin/bash

### Set the OpenShift Project to use
PROJECT=

### Create the Build Config
oc new-build --strategy docker --binary --docker-image centos:centos7 --name shellbox -n ${PROJECT}

### Start the Build
oc start-build shellbox --from-dir . --follow -n ${PROJECT}

### Deploy the Application
oc new-app shellbox --name shellbox -n ${PROJECT}

echo ""
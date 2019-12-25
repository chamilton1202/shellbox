#!/bin/bash

echo yes | keytool -import -alias ACompany \
-keystore /usr/lib/jvm/jre-openjdk/lib/security/cacerts \
-file ${APP_ROOT}/Cert.cer \
-storepass changeit \
-trustcacerts
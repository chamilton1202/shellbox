FROM centos:centos7

USER root

RUN yum install -y git vim wget curl && \
	yum install -y java-1.8.0-openjdk-devel && \
	yum clean all -y
RUN wget http://apache.claz.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp && \
	tar -xvf /tmp/apache-maven-3.6.3-bin.tar.gz -C /opt && \
	rm -f /tmp/apache-maven-3.6.3-bin.tar.gz && \
	ln -s /opt/apache-maven-3.6.3 /opt/maven
RUN echo <<EOF \
#!/bin/bash \
export JAVA_HOME=/usr/lib/jvm/jre-openjdk \
export M2_HOME=/opt/maven \
export MAVEN_HOME=/opt/maven \
export PATH=${M2_HOME}/bin:${PATH} \
EOF>> /etc/profile.d/maven.sh
RUN chmod +x /etc/profile.d/maven.sh && \
	source /etc/profile.d/maven.sh

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ ${APP_ROOT}/bin/
RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
ENTRYPOINT [ "uid_entrypoint" ]
VOLUME ${APP_ROOT}/logs ${APP_ROOT}/data
CMD run 

	
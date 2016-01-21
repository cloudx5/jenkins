FROM tomcat:6
WORKDIR /tmp

# Environment variables used throughout this Dockerfile
#
# $JENKINS_STAGING  will be used to download plugins and copy config files
#                   during the Docker build process.
#
# $JENKINS_HOME     will be the final destination that Jenkins will use as its
#                   data directory. This cannot be populated before Marathon
#                   has a chance to create the host-container volume mapping.
#
# $CATALINA_HOME    is derived from the official Tomcat Dockerfile:
#                   https://github.com/docker-library/tomcat/blob/df283818c1/8-jre8/Dockerfile
#
ENV JENKINS_HOME /var/jenkins_home
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH "${CATALINA_HOME}/bin:${PATH}"

RUN rm -rf $CATALINA_HOME/webapps/*

COPY jenkins_home/* "${JENKINS_HOME}/"
COPY tomcat/ "${CATALINA_HOME}/"
COPY other/tools.jar "/usr/lib/jvm/java-7-openjdk-amd64/lib/"

RUN apt-get update
RUN apt-get install -y git

EXPOSE 8080
CMD catalina.sh run

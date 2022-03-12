FROM jenkins/jenkins:lts-jdk11

USER root

RUN apt-get update && apt-get install python3-pip -y && \
    pip3 install ansible
RUN apt-get install lsof

WORKDIR /gradle
RUN curl -L https://services.gradle.org/distributions/gradle-7.4-bin.zip -o gradle-7.4-bin.zip
RUN unzip gradle-7.4-bin.zip
ENV GRADLE_HOME=/gradle/gradle-7.4
ENV PATH=$PATH:$GRADLE_HOME/bin

USER jenkins

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
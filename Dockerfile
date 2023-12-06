FROM jenkins/jenkins:lts-jdk11

USER root

RUN apt-get update
RUN apt-get install python3-pip -y
RUN pip3 install ansible --break-system-packages
RUN apt-get update
RUN apt-get install lsof

WORKDIR /gradle
RUN curl -L https://services.gradle.org/distributions/gradle-7.4-bin.zip -o gradle-7.4-bin.zip
RUN unzip gradle-7.4-bin.zip
ENV GRADLE_HOME=/gradle/gradle-7.4
ENV PATH=$PATH:$GRADLE_HOME/bin

COPY casc.yml /var/jenkins_home/casc_configs/jenkins.yml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY pluginInstall.sh /usr/share/jenkins/ref/pluginInstall.sh
RUN chmod 777 /var/jenkins_home/casc_configs/jenkins.yml
RUN chmod 777 /usr/share/jenkins/ref/plugins.txt
RUN chmod 777 /usr/share/jenkins/ref/pluginInstall.sh

USER jenkins

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc_configs/jenkins.yml

RUN /usr/share/jenkins/ref/pluginInstall.sh
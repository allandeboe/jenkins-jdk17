FROM jenkins/jenkins:lts-jdk17

#########################################################
USER root

# Install Docker
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y lsb-release

ENV DOCKER_KEYRING=/usr/share/keyrings/docker-archive-keyring.asc
ENV DOCKER_DOWNLOAD=https://download.docker.com/linux/debian

RUN curl -fsSLo $DOCKER_KEYRING $DOCKER_DOWNLOAD/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=${DOCKER_KEYRING}] $DOCKER_DOWNLOAD \
     $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && \
    apt-get install -y \
    docker-ce-cli

# Create the user "jenkins" and give them administrative (sudo) priviledges
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# Install shadow and add Jenkins into the group "admin"
COPY resources/shadow-amd64.deb ./shadow-prod.deb
RUN apt-get install ./shadow-prod.deb -y && \
    groupadd -g 50 staff --force && \
    usermod -a -G staff jenkins

#########################################################
USER jenkins

# Install Jenkins Plugins
RUN jenkins-plugin-cli --plugins \
    dark-theme \
    blueocean \
    build-environment \
    cloudbees-folder \
    config-file-provider \
    credentials-binding \
    credentials \
    docker-plugin \
    docker-slaves \
    docker-workflow \
    envinject \
    git \
    groovy \
    http_request \
    job-dsl \
    jobConfigHistory \
    naginator \
    pam-auth \
    pipeline-utility-steps \
    nexus-artifact-uploader \
    workflow-aggregator \
    sonar \
    subversion

# Copy Settings Described in "./resources" into image
COPY resources/basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy
COPY resources/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml

# Since we already handled set-up in this docker container
# we can simply ignore the setup wizard.
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

#########################################################
USER root
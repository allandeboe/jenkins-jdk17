# Jenkins - JDK17
functional, `jenkins/jenkins:lts-jdk17` docker image that is in dark mode by default and contains all relevant dependencies that make it easy to have Jenkins pipelines build and run docker images & containers. It also ensures that the Built-in Node has 0 executors.

I personally use this for my other project, [*Focust*](https://github.com/allandeboe/Focust-Web-App).

Based on [liatrio/alpine-jenkins](https://github.com/liatrio/alpine-jenkins), hence the same Apache 2.0 License. However, it is modified to work with `jenkins/jenkins:lts-jdk17` instead of `jenkins/jenkins:2.154-alpine` as well as to fit with my needs.

## Provided Jenkins Plugins
Here is the list of plugins that come pre-packaged with this image:

* [**Dark Theme**](https://plugins.jenkins.io/dark-theme/)
* [**Groovy**](https://plugins.jenkins.io/groovy/)
* [**Blue Ocean**](https://plugins.jenkins.io/blueocean/)
* [**Build Environment**](https://plugins.jenkins.io/build-environment/)
* [**Folders**](https://plugins.jenkins.io/cloudbees-folder/)
* [**Config File Provider**](https://plugins.jenkins.io/config-file-provider/)
* [**Credentials**](https://plugins.jenkins.io/credentials/)
* [**Credentials Binding**](https://plugins.jenkins.io/credentials-binding/)
* [**Pipeline**](https://plugins.jenkins.io/workflow-aggregator/)
* [**Pipeline Utility Steps**](https://plugins.jenkins.io/pipeline-utility-steps/)
* [**Git**](https://plugins.jenkins.io/git/)
* [**Docker**](https://plugins.jenkins.io/docker-plugin/)
* [**Docker Slaves**](https://plugins.jenkins.io/docker-slaves/)
* [**Docker Pipeline**](https://plugins.jenkins.io/docker-workflow/)
* [**Environment Injector**](https://plugins.jenkins.io/envinject/)
* [**HTTP Request**](https://plugins.jenkins.io/http_request/)
* [**Job DSL**](https://plugins.jenkins.io/job-dsl/)
* [**Job Configuration History**](https://plugins.jenkins.io/jobConfigHistory/)
* [**Naginator**](https://plugins.jenkins.io/naginator/)
* [**PAM Authentication**](https://plugins.jenkins.io/pam-auth/)
* [**Nexus Artifact Uploader**](https://plugins.jenkins.io/nexus-artifact-uploader/)
* [**SonarQube Scanner**](https://plugins.jenkins.io/sonar/)
* [**Subversion**](https://plugins.jenkins.io/subversion/)

This list is subject to change in future commits.

## Supported Tags
Here is the list of supported tags for this image:

* `latest`

## Build Image
If you want to build this image yourself, you first need to install a [Shadow debian package](https://update.shadow.tech/launcher/prod/linux/x86_64/shadow-amd64.deb) and place it inside of the `./resources/` directory as `shadow-amd64.deb` (using any other name for this `deb` package will require a modification to the `Dockerfile`).

One can then build the image, as follows:

```bash
docker build -t allandeboe/jenkins-jdk17:latest .
```

## Run Image
First make sure that there is a volume called `jenkins_home`. If it hasn't been created, you can run the following command:

```bash
docker volume create jenkins_home
```

Finally, to create the container, you simply have the run the docker container exactly as follows:

```bash
docker run --name jenkins \
-p 8080:8080 -p 50000:50000 \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
--restart=always \
allandeboe/jenkins-jdk17:latest
```

And you can access Jenkins through `http://localhost:8080`. The login credentials are `admin` for the username and `admin` for the password (you can change this by modifying the `resources/basic-security.groovy` file, although it requires re-building the image and container)
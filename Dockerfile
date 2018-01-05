# The MIT License
#
#  Copyright (c) 2015-2017, CloudBees, Inc.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

FROM jenkins/slave:3.15-1

MAINTAINER Tine Team <tineteam@bouvet.no>
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="3.15"

USER root

# Install prerequisites for Docker
# RUN cat /etc/apt/sources.list.apt-setup > /etc/apt/sources.list
RUN echo "deb http://cz.archive.ubuntu.com/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y --allow-unauthenticated sudo maven iptables libsystemd-journal0 apt-transport-https ca-certificates curl init-system-helpers libapparmor1 libltdl7 libseccomp2 software-properties-common python3-software-properties software-properties-common libdevmapper1.02.1 sysvinit-utils init-system-helpers && rm -rf /var/lib/apt/lists/*

ENV KUBERNETES_VERSION=v1.6.6
ENV DOCKER_VERSION=docker-ce_17.03.0~ce-0~ubuntu-trusty_amd64.deb

# Installing Docker CE
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Set up Kubernetes
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN chmod o+x kubectl
RUN ln -s kubectl /usr/local/bin/kubectl

# gcloud
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-183.0.0-linux-x86.tar.gz
RUN tar -zxvf google-cloud-sdk-183.0.0-linux-x86.tar.gz
RUN ./google-cloud-sdk/install.sh --quiet
RUN chmod 777 -R ./google-cloud-sdk
# RUN ./google-cloud-sdk/bin/gcloud init

COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]

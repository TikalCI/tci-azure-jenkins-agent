FROM centos:7.6.1810
USER root
WORKDIR /home

# install DOCKER

RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
RUN yum install -y docker-ce docker-cli

# install Microsoft Azure CLI

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN sh -c 'echo -e "[azure-cli]\n\
name=Azure CLI\n\
baseurl=https://packages.microsoft.com/yumrepos/azure-cli\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
RUN yum install -y azure-cli
RUN az acr helm install-cli --yes

# install HELM

RUN curl -L https://git.io/get_helm.sh | bash

# add jenkins user and make it a power user

RUN groupadd jenkins -g 1000
RUN useradd -c "Jenkins user" -d /home/jenkins -u 1000 -g jenkins -m jenkins
RUN sudo usermod -aG docker jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# switch to jenkins user

USER jenkins
WORKDIR /home/jenkins

#! /bin/bash

sudo yum upgrade -y

 sudo yum -y remove docker docker-client \
                   docker-client-latest \
                   docker-common \
                   docker-latest \
                   docker-latest-logrotate \
                   docker-logrotate \
                   docker-engine

sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install -y docker-ce-3:18.09.1-3.el7

sudo dnf install -y --nobest docker-ce

sudo dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
sudo systemctl enable --now docker
systemctl is-active docker

sudo docker pull ${docker_app_image}

sudo docker run -d -p ${instance_port}:${image_port} --env ENV=${env} --env PORT=${port} ${docker_app_image}

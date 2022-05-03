#!/bin/sh
set -x
$VM_USER=azure-user

echo "this has been written via cloud-init" + $(date) >> /tmp/myScript.txt
echo "write install script for java sdkman and python pyenv"

# check kvm
sudo chmod +x /dev/kvm
sudo lscpu | grep Virtualization

mkdir -p /home/azure-user
touch /home/azure-user/.bash_profile

# echo "writing out install script for sdkman and pyenv"
cat <<EOF | sudo tee /home/azure-user/install_sdkman_pyenv.sh
# install java
cd /home/azure-user
echo "installing sdkman and java"
curl -s "https://get.sdkman.io" | bash
echo 'source "/home/azure-user/.sdkman/bin/sdkman-init.sh"' | tee -a /home/azure-user/.bash_profile

# install java and maven using sdkman
# have to do this as the sdkman script has unbounded variable or something
set +u
source "/home/azure-user/.sdkman/bin/sdkman-init.sh" && sdk install java 11.0.11.hs-adpt && sdk install maven

# install pyenv
echo "installing pyenv"
git clone https://github.com/pyenv/pyenv.git /home/azure-user/.pyenv

/home/azure-user/.pyenv/bin/pyenv install 3.9.12

echo 'export PYENV_ROOT="/home/azure-user/.pyenv"' >> /home/azure-user/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/azure-user/.bash_profile
echo 'eval "$(/home/azure-user/.pyenv/bin/pyenv init -)"' >> /home/azure-user/.bash_profile
EOF

chmod +x /home/azure-user/install_java_py.sh

sudo apt update -y

# install git and python pyenv dependencies
echo "installing git, other dependencies"
sudo apt install -y make git zip unzip wget jq
sudo apt-get -y install python-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl

# install docker
echo "installing Docker CE"
sudo apt-get install -y\
     ca-certificates \
     curl \
     gnupg \
     lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo systemctl enable docker
sudo usermod -aG docker azure-user
sudo newgrp docker
sudo systemctl start docker.service

# enable and start docker daemon
echo "service enable and start docker"
sudo systemctl enable --now docker

# compose
echo "installing docker-compose"
sudo curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# install node
echo "installing node"
sudo apt install nodejs -y

# install golang
echo "installing go"
sudo apt install golang-go

# update for installing python using pyenv
sudo apt-get install -y git python-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl

# install JDK 11
sudo apt install -y openjdk-11-jre-headless

# install python3
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update -y
sudo apt install python3.9

# install minikube
echo "installing minikube"
curl -Lo /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x /usr/local/bin/minikube

# install kind
echo "installing kind"
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/

# install aws cli
echo "installing AWS CLI"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# install azure cloud CLI
echo "installing Azure CLI"
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli

# utilities
# install kubectl and gcloud-cli
echo "installing kubectl"
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

sudo apt-get update -y && sudo apt-get install -y kubectl google-cloud-cli

# grype for vulnerabilities
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

# eksctl
sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# ecs-cli
sudo curl -Lo /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest

# terraform
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

terraform -help

# k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# k3s
sudo curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.23.6%2Bk3s1/k3s
sudo chmod +x /usr/local/bin/k3s

# dive for docker
DIVE_VERSION=$(curl -s "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo dive.deb "https://github.com/wagoodman/dive/releases/latest/download/dive_${DIVE_VERSION}_linux_amd64.deb"
sudo apt install -y ./dive.deb
dive --version
rm -rf dive.deb

# docker image tar extract utility
sudo curl -Lo /usr/local/bin/docker-image-extract  https://gist.githubusercontent.com/smijar/0f4a5a8a8ce69ed54baa6e82063ff074/raw/e4f50bc636a27d88aa1a3fbf3073ceff271bbf4b/docker-image-extract.py
sudo chmod +x /usr/local/bin/docker-image-extract

# install kontain
sudo mkdir -p /opt/kontain ; sudo chown root /opt/kontain
curl -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/kontain-install.sh | sudo bash

# clone Kontain examples
git clone https://github.com/kontainapp/guide-examples.git
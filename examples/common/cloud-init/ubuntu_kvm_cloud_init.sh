#!/bin/sh
set -xe

echo "this has been written via cloud-init" + $(date) >> /tmp/myScript.txt
echo "write install script for java sdkman and python pyenv"

# check kvm
sudo chmod +x /dev/kvm
sudo lscpu | grep Virtualization

mkdir -p /home/azure-user
touch /home/azure-user/.bash_profile

sudo apt update -y

# install git and python pyenv dependencies
echo "installing git, other dependencies"
sudo apt install -y make gcc g++ git zip unzip wget jq curl

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
echo "installing node 12 or above"
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt -y install nodejs

sudo apt install nodejs -y

# install golang
echo "installing go"
sudo apt install -y golang-go

cat<<EOF >> /home/azure-user/.bash_profile
export GOPATH='/home/azure-user/go'
export GOROOT='/usr/local/go'
export PATH="$PATH:/usr/local/bin:$GOROOT/bin:$GOPATH/bin"
export GO111MODULE="on"
export GOSUMDB=off
EOF

#----------------------------------------
# using sdkman and pyenv since we will need to keep switching versions for testing
# # install JDK 11
# sudo apt install -y openjdk-11-jdk maven

# # install python3
# sudo add-apt-repository ppa:deadsnakes/ppa
# sudo apt update -y
# sudo apt install python3.9

#----------------------------------------
# installing python using pyenv as yum breaks when using yum and update-alternatives
echo "installing Python 3.9"
# install dependencies
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

# ref: https://www.singlestoneconsulting.com/blog/setting-up-your-python-environment/
sudo runuser -l azure-user -c "curl https://pyenv.run | bash"
sudo runuser -l azure-user -c "/home/azure-user/.pyenv/bin/pyenv install 3.9.12"
sudo runuser -l azure-user -c "/home/azure-user/.pyenv/bin/pyenv global 3.9.12"

cat<<EOF >> /home/azure-user/.bash_profile
export PATH="\$HOME/.pyenv/bin:$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF

sudo runuser -l azure-user -c echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> /home/azure-user/.bash_profile
sudo runuser -l azure-user -c echo 'eval "$(pyenv init -)"' >> /home/azure-user/.bash_profile
sudo runuser -l azure-user -c echo 'eval "$(pyenv virtualenv-init -)"' >> /home/azure-user/.bash_profile

# installing JDK
echo "installing JDK 11"
# NOTE - cant use amazon-linux-extras as they default to openjdk-17 or yum - as it installs older version fo maven - HAVE TO USE SDKMAN
echo "installing sdkman and java"

sudo runuser  -l azure-user -c 'curl -s "https://get.sdkman.io" | bash'
sudo runuser  -l azure-user -c 'source /home/azure-user/.sdkman/bin/sdkman-init.sh && sdk install java 11.0.11.hs-adpt && sdk install maven'
sudo runuser  -l azure-user -c ''
cat <<EOF  >> /home/azure-user/.bash_profile
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="\$HOME/.sdkman"
[[ -s "\$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "\$HOME/.sdkman/bin/sdkman-init.sh"
EOF

#----------------------------------------
# install kustomize
sudo curl -Lo /usr/local/bin/kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v3.2.3/kustomize_kustomize.v3.2.3_linux_amd64
sudo chmod +x /usr/local/bin/kustomize

# install minikube
echo "installing minikube"
curl -Lo /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x /usr/local/bin/minikube

# install kind
echo "installing kind"
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/

# install azure cloud CLI
echo "installing Azure CLI"
sudo apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update -y
sudo apt-get install -y azure-cli

# utilities
# install kubectl
echo "installing kubectl"
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

sudo apt-get update -y && sudo apt-get install -y kubectl

# grype for vulnerabilities
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

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
cd /home/azure-user
runuser -l azure-user -c 'git clone https://github.com/kontainapp/guide-examples.git'
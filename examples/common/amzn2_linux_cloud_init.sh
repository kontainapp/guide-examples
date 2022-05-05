#!/bin/bash
#set -e; [ "$TRACE" ] && set -x
set -e
set -x

# figure out the latest release
# This script must be run as root.
[ `id -u` != "0" ] && echo "Must run as root" && exit 1

source /etc/os-release
[ "$ID" != "fedora" -a "$ID" != "ubuntu" -a "$ID" != "amzn" ] && echo "Unsupported linux distribution: $ID" && exit 1

#TAG=${1:-$(curl -L -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/current_release.txt)}
# forcing it to be latest
TAG='latest'
if [[ $TAG = latest ]] ; then
   readonly URL_KONTAIN_TAR_GZ="https://github.com/kontainapp/km/releases/${TAG}/download/kontain.tar.gz"
   readonly URL_KONTAIN_BIN="https://github.com/kontainapp/km/releases/${TAG}/download/kontain_bin.tar.gz"
else
   readonly URL_KONTAIN_TAR_GZ="https://github.com/kontainapp/km/releases/download/${TAG}/kontain.tar.gz"
   readonly URL_KONTAIN_BIN="https://github.com/kontainapp/km/releases/download/${TAG}/kontain_bin.tar.gz"
fi
readonly PREFIX="/opt/kontain"


# install yum-utils which contains needs-restarting to check if a reboot is necessary after update
yum install -y yum-utils git
yum update -y

# check if it needs rebooting while yum not running
# ensure that cloud-init runs again after reboot by removing the instance record created
(test ! -f /var/run/yum.pid && needs-restarting -r) || (rm -rf /var/lib/cloud/instances/;reboot)

# install docker
amazon-linux-extras install docker
systemctl enable docker
# systemctl enable --now docker
# start/restart at the end

# and include ec2-user in docker group
usermod -a -G docker ec2-user
newgrp docker

# install docker-compose
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
chmod -v +x /usr/local/bin/docker-compose

# install utils
cd /tmp
yum install -y jq wget

# download and move files into place
mkdir /tmp/kontain
cd /tmp/kontain
wget $URL_KONTAIN_BIN
tar xvzf kontain_bin.tar.gz

# move files into /opt/kontain
mkdir -p /opt/kontain/bin; chown root /opt/kontain
mv container-runtime/krun /opt/kontain/bin/
mv km/km /opt/kontain/bin/
mv bin/docker_config.sh /opt/kontain/bin/

# install KKM
./kkm.run

# configure and restart docker with Kontain as runtime
# systemctl restart --no-block docker
bash /opt/kontain/bin/docker_config.sh


# installing JDK
echo "installing JDK 11"
sudo amazon-linux-extras install -y java-openjdk11
sudo yum install -y maven

# installing nodejs
echo "installing nodejs"
cd /tmp
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
sudo yum install -y nodejs

# install golang
echo "installing golang"
mkdir -p /home/ec2-user/go/src

# add golang path
cd /tmp
sudo mkdir -p /home/ec2-user/go/bin
sudo yum install -y golang

cat<<EOF >> /home/ec2-user/.bash_profile
export GOPATH='/home/ec2-user/go'
export GOROOT='/usr/local/go'
export PATH="$PATH:/usr/local/bin:$GOROOT/bin:$GOPATH/bin"
export GO111MODULE="on"
export GOSUMDB=off
EOF

# install python 3.9
echo "installing python"
sudo amazon-linux-extras install -y python3.8
# cannot do the following as it breaks yum
# sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

#install minikube so we have kubernetes testing
echo "installing minikube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

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

# utilities
# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# grype for vulnerabilities
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

# k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# k3s
sudo curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.23.6%2Bk3s1/k3s
sudo chmod +x /usr/local/bin/k3s

# dive for docker images
sudo rpm -i https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.rpm

# docker image tar extract utility
sudo curl -Lo /usr/local/bin/docker-image-extract  https://gist.githubusercontent.com/smijar/0f4a5a8a8ce69ed54baa6e82063ff074/raw/e4f50bc636a27d88aa1a3fbf3073ceff271bbf4b/docker-image-extract.py
sudo chmod +x /usr/local/bin/docker-image-extract

# clone Kontain examples
cd /home/ec2-user
git clone https://github.com/kontainapp/guide-examples.git
chown -R ec2-user:ec2-user *

# Pre-requisites
Kontain runs on Linux kernel version 4.15 or newer, running on Intel VT (vmx) or AMD (svm) with KVM based virtualization enabled, ideally Ubuntu or Fedora. For enabling KVM on Ubuntu 18.04 or higher, you can refer to this article.

Recommended distros are Ubuntu 20.04 and Fedora 32, or newer. Note that this also assumes that your user has access to /dev/kvm.

# check for pre-requisites
```
# verify that you have a 64-bit Linux kernel version 4.15 or higher
$ uname -m
x86_64
$ uname -r
5.14.14-200.fc34.x86_64

# verify that you have nested virtualization turned on
$ cat /proc/cpuinfo| egrep "vmx|svm" | wc -l
# output must be greater than 0

# verify that you have KVM already installed /dev/kvm enabled by checking:
$ ls -l /dev/kvm

# verify that Docker is installed
$ systemctl|grep docker.service
  docker.service
  ```

  *Note*: If Docker is not present, you can install Docker On Fedora/RHEL systems using instructions from here or for Ubuntu using these instructions.

# Install Kontain
```bash
# create the kontain folder for install
$ sudo mkdir -p /opt/kontain ; sudo chown root /opt/kontain

$ # download and install the latest Kontain release
$ curl -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/kontain-install.sh | sudo bash

# check for Kontain in /opt/kontain folder
$ ls -l /opt/kontain
```

# Verify if Kontain can run after install
```bash
# check if Kontain monitor can run the unikernel
$ /opt/kontain/bin/km /opt/kontain/tests/hello_test.km

# check with docker can run with kontain as runtime
$ docker run --runtime=krun kontainguide/hello-kontain
```

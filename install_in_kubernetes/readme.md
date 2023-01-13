# Pre-requisites
Please note that Kontain runs on Linux kernel version 4.15 or newer, running on Intel VT (vmx) or AMD (svm) with KVM based virtualization enabled, ideally Ubuntu or Fedora.

So this would be required for the Kubernetes worker node.

For enabling KVM on Ubuntu 18.04 or higher, you can refer to this [article](https://linuxize.com/post/how-to-install-kvm-on-ubuntu-18-04/).

Recommended distros are Ubuntu 20.04 and Fedora 32, or newer. Note that this also assumes that your user has access to /dev/kvm.

# Install in Kubernetes
Please note the pre-requisites above for trying out Kontain on Kubernetes node.

For example, you can install on Minikube or k3s using the instructions below on a desktop that meets the requirements above.

Please refer to this page for installing Kontain in any version of Kubernetes (for example - AWS AKS, Google Cloud GKE, Azure AKS, K3s, Openshift):

[!Install in Kubernetes](https://github.com/kontainapp/guide-examples/tree/master/install_in_kubernetes)


## Post install steps
```bash
# verify that the daemonset is in "Running" state
$ kubectl get po -n kube-system
kube-system   azure-ip-masq-agent-tr7c7             1/1     Running   0          37m
kube-system   coredns-58567c6d46-ncsqq              1/1     Running   0          38m
kube-system   coredns-58567c6d46-rrb4m              1/1     Running   0          36m
kube-system   coredns-autoscaler-54d55c8b75-j97sj   1/1     Running   0          38m
kube-system   kontain-node-initializer-tvr84        1/1     Running   0          39s
kube-system   kube-proxy-7hkjc                      1/1     Running   0          37m
kube-system   metrics-server-569f6547dd-flsb4       1/1     Running   1          38m
kube-system   tunnelfront-7d8df6bfdc-dr6z2          1/1     Running   0          38m

# if need be, to debug an "Error" state, you can view its logs:
$ kubectl logs kontain-node-initializer-<id>

# check the daemonset state
$ kubectl get daemonsets.apps -A
```

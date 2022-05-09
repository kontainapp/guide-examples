# Pre-requisites
Please note that Kontain runs on Linux kernel version 4.15 or newer, running on Intel VT (vmx) or AMD (svm) with KVM based virtualization enabled, ideally Ubuntu or Fedora.

So this would be required for the Kubernetes worker node.

For enabling KVM on Ubuntu 18.04 or higher, you can refer to this [article](https://linuxize.com/post/how-to-install-kvm-on-ubuntu-18-04/).

Recommended distros are Ubuntu 20.04 and Fedora 32, or newer. Note that this also assumes that your user has access to /dev/kvm.

# Install in Kubernetes
Please note the pre-requisites above for trying this out on a desktop or Cloud VM.

For example, you can install on Minikube using the instruction below on a desktop that meets the requirements above.

Install Kontain using a Daemonset
```bash
# apply the daemonset
$ kubectl apply -f curl https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml
```

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

# To install Kontain on Azure AKS
The above instructions work well for Azure AKS that is run with a minimum instance being Standard_D4s_v3.

This is because this enables nested virtualization by default on that worker node to be able to utilize the power Kontain's virtualization fully.

# To install Kontain on AWS and GKE
To install Kontain on AWS (with containerd) or GKE use:

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/kkm.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.

As Docker shim is being deprecated in AWS EKS, please note that to use Kontain on AWS EKS, you will need to launch the cluster using containerd as the default runtime. Please see: Docker shim deprecation

To enable containerd as default rutime, please see: Enabling Containerd in EKS

# K3s
To install Kontain on K3s:

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/kkm.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.


# Openshift with CRIO
To install Kontain on Openshift with CRIO:

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km-crio.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.

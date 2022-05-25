## repo
https://artifacthub.io
simplest: https://artifacthub.io/packages/helm/carlosjgp/node-problem-detector?modal=template&template=daemonset.yaml

## install helm 3
ref: https://helm.sh/docs/intro/install/

```shell
$ curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

## Usage
ref: https://helm.sh/docs/intro/
ref for templates: https://helm.sh/docs/chart_template_guide/getting_started/

#### create new chart
```shell
$ helm create kontain
# creates a new chart - update then go into ./kontain/templates and delete everything and recreate files
```

#### Doing dry-runs to see outputs:
```shell
# default = km-based install
$ helm install kontain ./kontain --dry-run
or
$ helm install kontain ./kontain --dry-run --set install_type=km

# default for kkm-based install
$ helm install kontain ./kontain --dry-run --set install_type=kkm

# default for k3s install
$ helm install kontain ./kontain --dry-run --set install_type=k3s

# default for k3s install
$ helm install kontain ./kontain --dry-run --set install_type=km-crio
```

## test
```shell
# create the cluster
# kind, k3d or minikube-crio

# for km-based install
$ helm install kontain ./kontain --set install_type=km
OR
# for kkm-based install
$ helm install kontain ./kontain --set install_type=kkm
OR
# for k3s-based install
$ helm install kontain ./kontain --set install_type=kkm
OR
# for km-crio install
$ helm install kontain ./kontain --set install_type=kkm

# delete the cluster
# kind, k3d or minikube-crio
```

## packaging
```shell
$ helm package kontain
```
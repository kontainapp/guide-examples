#----------------------
# instance sizes: https://docs.microsoft.com/en-us/azure/virtual-machines/dv3-dsv3-series
# Azure VM
#----------------------
clouddevvmazure-up:
	az vm create \
	--name sm_dev2 \
	--resource-group kdocs \
	--size Standard_D4s_v3 \
	--image "Canonical:0001-com-ubuntu-confidential-vm-focal:20_04-lts-gen2:20.04.202110290" \
	--ssh-key-name sm-key \
	--admin-username azure-user \
	--custom-data ./cloud-init/ubuntu_kvm_devvm_init.sh

cloudvmazure-up:
	az vm create \
	--name trial_vm1 \
	--resource-group kdocs \
	--size Standard_D4s_v3 \
	--image "Canonical:0001-com-ubuntu-confidential-vm-focal:20_04-lts-gen2:20.04.202110290" \
	--ssh-key-name sm-key \
	--admin-username azure-user \
	--custom-data ./cloud-init/ubuntu_kvm_cloud_init.sh
	sleep 20

cloudvmazure-clean:
	az vm delete --resource-group kdocs --name trial_vm1 --yes
	sleep 10

cloudvmazure-list:
	az vm list --resource-group kdocs -o table
	az vm list-ip-addresses --resource-group kdocs --name sm_dev -o table
	az network public-ip list -o table

#----------------------
# AWS VM
#----------------------
cloudvmaws-up:
	export AWS_PAGER=""
	aws ec2 run-instances \
	--image-id ami-0022f774911c1d690 \
	--security-group-ids sg-0b8cf89d293b7adfc \
	--instance-type t3.medium \
	--key-name sm-key \
	--count 1 \
	--no-paginate \
	--tag-specifications 'ResourceType=instance,Tags=[{Key=usage,Value=guide-examples}]' 'ResourceType=volume,Tags=[{Key=usage,Value=guide-examples}]' \
	--user-data file://cloud-init/amzn2_linux_cloud_init.sh
	sleep 20
	
cloudvmaws-clean:
	# prevents pagin with aws commands
	export AWS_PAGER=""
	aws ec2 terminate-instances --instance-ids `aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --filters "Name=tag:usage,Values=guide-examples" --output text`
	sleep 10

cloudvmaws-list:
	export AWS_PAGER=""
	aws ec2 describe-instances \
		--query 'Reservations[].Instances[].InstanceId' \
		--filters "Name=tag:usage,Values=guide-examples" \
		--output text
	# get the ip addresses
	aws ec2 describe-instances \
		--query "Reservations[].Instances[][PublicIpAddress]" \
		--filters "Name=tag:usage,Values=guide-examples" \
		--output text | grep -v "None"

cloudvmaws-ssh:
	# works well when there's only 1 instance running
	ssh ec2-user@`aws ec2 describe-instances \
		--query "Reservations[].Instances[][PublicIpAddress]" \
		--filters "Name=tag:usage,Values=guide-examples" \
		--output text | grep -v "None"`

#----------------------
# kind cluster
#----------------------
kindcluster:
	echo
	echo "creating kind cluster: kind-kind"
	kind create cluster --wait 5m
	- kubectl config set-context "kind-kind"
	kubectl config current-context

	echo "waiting for all pods to be ready before cluster can be used"
	kubectl wait --for=condition=Ready pods --all --all-namespaces
	sleep 10


kindcluster-apply-km:
	echo
	echo "applying km to kind cluster: kind-kind"
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide/main/_k8s/kustomize_outputs/km.yaml

	sleep 5

	echo "waiting for kontain-node-initializer to be ready"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 5
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-kind.log

	sleep 20
	kubectl get po -A
	cat /tmp/kontain-node-initializer-kind.log	


kindcluster-clean:
	echo
	echo "deleting kind cluster: kind-kind"
	- kubectl config delete-context "kind-kind"
	kind delete cluster
	sleep 5

#----------------------
# minikube cluster
#----------------------
minikubecluster:
	echo "creating minikube cluster: minikube"
	minikube start --container-runtime=containerd --driver=docker --wait=all
	- kubectl config set-context minikube
	kubectl config current-context

minikubecluster-clean:
	echo "deleting k3d cluster: minikube"
	- kubectl config delete-context minikube
	minikube delete
	k3d cluster delete

minikubecluster-apply-km:
	echo
	echo "applying km to minikube cluster: minikube"
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide/main/_k8s/kustomize_outputs/km.yaml

	sleep 5

	echo "waiting for kontain-node-initializer to be ready"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 5
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-kind.log

	sleep 5

#----------------------
# AKS Cluster
#----------------------
akscluster:
	echo "setting up 1-node AKS cluster - kdocscluster-aks - using Dsv3 instance type"
	# az aks create -g kdocs -n "kdocscluster-aks" --enable-managed-identity --node-count 1 --generate-ssh-keys --node-vm-size Standard_D4s_v3
	az aks create -g kdocs -n "kdocscluster-aks" --enable-managed-identity --node-count 1 --ssh-key-value ${HOME}/.ssh/id_rsa.pub --node-vm-size Standard_D4s_v3

	# setup kubectl and its context
	az aks get-credentials --resource-group kdocs --name "kdocscluster-aks"
	# - kubectl config set-context "kdocscluster-aks"
	kubectl config current-context

	echo "waiting for all pods to be ready before cluster can be used"
	kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=720s
	sleep 10


akscluster-apply-km:
	echo "applying km to kind cluster: kdocscluster-aks"
	# kubectl apply -f kustomize_outputs/km.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide/main/_k8s/kustomize_outputs/km.yaml
	sleep 5

	echo "waiting for kontain-node-initializer to be ready"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 10
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-aks.log

	sleep 10
	echo "showing output of node-initializer log"
	cat /tmp/kontain-node-initializer-aks.log

	sleep 10


akscluster-apply-flaskapp:
	echo "deploying kontain flask app to cluster: kdocscluster-aks"

	# cleaning the app in case its already deployed, ignore error if present
	- kubectl delete -f apps/pyflaskappkontain.yml
	sleep 5

	echo "deploying the Kontain flask app"
	# kubectl apply -f apps/pyflaskappkontain.yml && kubectl rollout status deployment/flaskappkontain --timeout=60s
	kubectl apply -f apps/pyflaskappkontain.yml
	sleep 3

	echo "waiting for flask app to be ready"
	kubectl -n default wait pod --for=condition=Ready -l app=flaskappkontain --timeout=240s

	echo "getting pods in default NS"
	kubectl get po

akscluster-clean:
	echo "deleting cluster: kdocscluster_aks"
	- kubectl config delete-context "kdocscluster-aks"
	az aks delete -y --name "kdocscluster-aks" --resource-group kdocs

#------------------
# GKE cluster
#------------------
gke-setup:
	echo "setup gcloud CLI"
	# gcloud init with project and region

gkecluster:
	echo "setting up 1-node GKE cluster - kdocscluster-gke - using n2-standard-2 instance type"
	gcloud config set compute/zone "us-central1-c"
	gcloud config set project "gke-suport"
	gcloud beta container \
		clusters create "kdocscluster-gke" \
		--zone "us-central1-c" \
		--no-enable-basic-auth \
		--machine-type "n2-standard-2" \
		--image-type "UBUNTU_CONTAINERD" \
		--disk-type "pd-ssd" \
		--disk-size "50" \
		--num-nodes "1" \
		--node-locations "us-central1-c"

	# setup kubectl and its context
	gcloud container clusters get-credentials "kdocscluster-gke"
	# - kubectl config set-context "kdocscluster-gke"
	kubectl config current-context

	echo "waiting for all pods to be ready before cluster can be used"
	kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=720s
	sleep 15

gkecluster-apply-kkm:
	echo "applying kkm to kind cluster: kdocscluster-gke"
	# kubectl apply -f kustomize_outputs/kkm.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide/main/_k8s/kustomize_outputs/kkm.yaml
	sleep 5

	echo "waiting for kontain-node-initializer to be running and applying KKM"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 60
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-gke.log

	sleep 15
	echo "showing output of node-initializer log"
	cat /tmp/kontain-node-initializer-gke.log

gkecluster-apply-flaskapp:
	echo "deploying kontain flask app to cluster: kdocscluster-gke"
	
	# cleaning the app in case its already deployed, ignore error if present
	- kubectl delete -f apps/pyflaskappkontain.yml
	sleep 5

	echo "deploying the Kontain flask app"
	# kubectl apply -f apps/pyflaskappkontain.yml && kubectl rollout status deployment/flaskappkontain --timeout=60s
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide/main/_k8s/kustomize_outputs/kkm.yaml
	sleep 3

	echo "waiting for flask app to be ready"
	kubectl -n default wait pod --for=condition=Ready -l app=flaskappkontain --timeout=240s

	echo "getting pods in default NS"
	kubectl get po

gkecluster-clean:
	echo "deleting cluster: kdocscluster-gke"
	- kubectl config delete-context "kdocscluster-gke"
	gcloud container clusters delete --quiet "kdocscluster-gke"

#--------------
# EKS Cluster
#--------------
ekscluster:
	# 1-time task as it takes way too long to create a k8s cluster from scratch in cloudformation (sets up private subnet etc.)
	echo "setting up 1-node EKS cluster - kdocscluster-eks-2 - using t2.medium instance type"
	eksctl create cluster -f conf/aws_eksctl.conf
	# eksctl utils update-cluster-logging --enable-types={SPECIFY-YOUR-LOG-TYPES-HERE (e.g. all)} --region=us-west-2 --cluster=kdocscluster-eks

ekscluster-add-ng:
	echo "setting up nodegroup for a 1-node EKS cluster - kdocscluster-eks-2 - using t2.small instance type"

	# it takes too long to create a cluster with the huge cloudformation stack generated, hence we will just add a nodegroup
	eksctl create nodegroup --config-file=./conf/aws/kdocscluster-eks-2.yaml

	# update kubeconfig
	aws eks update-kubeconfig --region us-west-2 --name "kdocscluster-eks-2"
	kubectl config current-context

	echo "waiting for all pods to be ready before cluster can be used"
	kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=720s
	sleep 10

ekscluster-apply-kkm:
	echo "applying kkm to kind cluster: kdocscluster-eks-2"
	# kubectl apply -f kustomize_outputs/kkm.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide/main/_k8s/kustomize_outputs/kkm.yaml
	sleep 15

	echo "waiting for kontain-node-initializer to be running and applying KKM"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=420s

	sleep 100
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-eks.log

	sleep 5
	echo "showing output of node-initializer log"
	cat /tmp/kontain-node-initializer-gke.log

ekscluster-apply-flaskapp:
	echo "deploying kontain flask app to cluster: kdocscluster-eks-2"

	# cleaning the app in case its already deployed, ignore error if present
	- kubectl delete -f apps/pyflaskappkontain.yml
	sleep 5

	echo "deploying the Kontain flask app"
	# kubectl apply -f apps/pyflaskappkontain.yml && kubectl rollout status deployment/flaskappkontain --timeout=60s
	kubectl apply -f apps/pyflaskappkontain.yml
	sleep 3

	echo "waiting for flask app to be ready"
	kubectl -n default wait pod --for=condition=Ready -l app=flaskappkontain --timeout=240s

	echo "getting pods in default NS"
	kubectl get po

ekscluster-drain-ng:
	# takes too long to rebuild cluster hence not doing $ eksctl delete cluster --region=us-west-2 --name=kdocscluster-eks
	# we will just remove the node group, and scale it down to 0 to remove the nodes, ignore the pod disruption budgets
	echo "removing kontain-node-initializer"
	- kubectl delete deploy/flaskappkontain
	- kubectl delete daemonset/kontain-node-initializer -n kube-system
	sleep 5
	echo "draining the nodegroup to clean: kdocscluster-eks"
	eksctl drain nodegroup --cluster=kdocscluster-eks-2 --name=kdocscluster-eks-2-ng-1 --disable-eviction
	eksctl scale nodegroup --cluster=kdocscluster-eks-2 --name=kdocscluster-eks-2-ng-1 --nodes=0
	eksctl delete nodegroup --cluster=kdocscluster-eks-2 --name=kdocscluster-eks-2-ng-1 --disable-eviction
	# just to make sure node is removed
	eksctl delete nodegroup  --config-file=conf/aws/kdocscluster-eks-2.yaml --approve

	- kubectl config delete-context "kdocscluster-eks-2"

ekscluster-clean:
	eksctl delete cluster --name EKS
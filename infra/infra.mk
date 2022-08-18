.PHONY: build

# used when wanting to rsync (. hidden) files
#SHELL := bash -O dotglob or extglob
SHELL := /bin/bash

.EXPORT_ALL_VARIABLES:

# include environment variables file
ifneq (,$(wildcard ./env.vars))
    include  env.vars
    export
endif

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
	--custom-data ./cloud-init/ubuntu_kvm_cloud_init.sh
	sleep 20

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
# AWS VM
#----------------------
build-overlays:
	mkdir -p ./kustomize_outputs/
	mkdir -p /tmp/kustomize_outputs/

	echo "building overlays for km, kkm, km-crio"
	# to apply directly, use:
	# 	/usr/local/bin/kustomize build "https://github.com/kontainapp/km/cloud/k8s/deploy/kontain-deploy/base?ref=sm/k8s-kkm-amzn" | kubectl apply -f -
	/usr/local/bin/kustomize build "https://github.com/kontainapp/km//cloud/k8s/deploy/kontain-deploy/base?ref=sm/k8s-kkm-amzn" > /tmp/kustomize_outputs/km.yaml
	/usr/local/bin/kustomize build "https://github.com/kontainapp/km//cloud/k8s/deploy/kontain-deploy/overlays/km-crio?ref=sm/k8s-kkm-amzn" > /tmp/kustomize_outputs/km-crio.yaml
	/usr/local/bin/kustomize build "https://github.com/kontainapp/km//cloud/k8s/deploy/kontain-deploy/overlays/kkm?ref=sm/k8s-kkm-amzn" > /tmp/kustomize_outputs/kkm.yaml

	cp /tmp/kustomize_outputs/k*.yaml ./kustomize_outputs

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
	# kubectl apply -f ./kustomize_outputs/km.yaml
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml

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
	# kubectl apply -f ./kustomize_outputs/km.yaml
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml

	sleep 5

	echo "waiting for kontain-node-initializer to be ready"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 5
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-kind.log

	sleep 5

#----------------------
#
# AKS Cluster
# we use kdocs-cluster-aks as the stable one and kdocs-cluster-aks-dev as the dev one
# $ make -f infra.mk akscluster AKSCLUSTERNAME="kdocs-cluster-aks" or
# $ make -f infra.mk akscluster AKSCLUSTERNAME="kdocs-cluster-aks-dev"
# $ make -f infra.mk akscluster AKSCLUSTERNAME="aks-kontain-trial"
# for kubectl:
# $ az aks get-credentials --resource-group kdocs --name "${AKSCLUSTERNAME}"

# az aks get-credentials --resource-group kdocs --name "aks-kontain-trial"

# az aks get-credentials --resource-group kdocs --name "kdocs-cluster-aks"
# az aks get-credentials --resource-group kdocs --name "kdocs-cluster-aks-dev"
#----------------------
akscluster:
ifdef AKSCLUSTERNAME
		echo "setting up 1-node AKS cluster - ${AKSCLUSTERNAME} - using Dsv3 instance type"
		# az aks create -g kdocs -n "${AKSCLUSTERNAME}" --enable-managed-identity --node-count 1 --generate-ssh-keys --node-vm-size Standard_D4s_v3
		az aks create -g kdocs -n "${AKSCLUSTERNAME}" --enable-managed-identity --node-count 1 --ssh-key-value ${HOME}/.ssh/cluster-key.pub --node-vm-size Standard_D4s_v3

		# setup kubectl and its context
		az aks get-credentials --resource-group kdocs --name "${AKSCLUSTERNAME}"
		# - kubectl config set-context "${AKSCLUSTERNAME}"
		kubectl config current-context

		echo "waiting for all pods to be ready before cluster can be used"
		kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=720s
		sleep 10
else
		@echo 1>&2 "AKSCLUSTERNAME must be set - can be either kdocs-cluster-aks or kdocs-cluster-aks-dev"
		false # Cause target to fail
endif


akscluster-apply-km:
ifdef AKSCLUSTERNAME
	echo "applying km to kind cluster: ${AKSCLUSTERNAME}"
	# kubectl apply -f kustomize_outputs/km.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	# kubectl apply -f ./kustomize_outputs/km.yaml
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml
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
else
		@echo 1>&2 "AKSCLUSTERNAME must be set - can be either kdocs-cluster-aks or kdocs-cluster-aks-dev"
		false # Cause target to fail
endif

akscluster-clean:
ifdef AKSCLUSTERNAME
	echo "deleting cluster: kdocscluster_aks"
	- kubectl config delete-context "${AKSCLUSTERNAME}"
	az aks delete -y --name "${AKSCLUSTERNAME}" --resource-group kdocs
else
		@echo 1>&2 "AKSCLUSTERNAME must be set - can be either kdocs-cluster-aks or kdocs-cluster-aks-dev"
		false # Cause target to fail
endif


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
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/kkm.yaml
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
	# kubectl apply -f./kustomize_outputs/kkm.yaml
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/kkm.yaml
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
# optional in case above creation times out before kubecontext updated
ekscluster-kubectl-configure:
	aws eks update-kubeconfig --region us-east-1 --name "kdocscluster-eks"

ekscluster:
	echo "setting up 1-node EKS cluster - kdocscluster-eks - using t2.medium instance type"
	eksctl create cluster -f conf/aws_eksctl.conf

	# NOTE: can enable logging using below:
	# 	eksctl utils update-cluster-logging \
	#		--enable-types={SPECIFY-YOUR-LOG-TYPES-HERE (e.g. all)} \
	#		--region=us-east-1 --cluster=kdocscluster-eks'

	# update local kubeconfig
	aws eks update-kubeconfig --region us-east-1 --name "kdocscluster-eks"
	kubectl config current-context

	echo "waiting for all pods to be ready before cluster can be used"
	kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=720s
	sleep 10

ekscluster-ng:
	# providing this as a way to add nodegroups only because it can take too long to create a cluster if VPC not pre-created
	echo creating nodegroups from config
	eksctl create nodegroup --config-file=conf/aws_eksctl.conf

ekscluster-apply-kkm:
	echo "applying kkm to kind cluster: kdocscluster-eks"
	# kubectl apply -f kustomize_outputs/kkm.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/kkm.yaml
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
	echo "deploying kontain flask app to cluster: kdocscluster-eks"

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

ekscluster-clean-ng:
	# it can too long to rebuild cluster so providing this if needing to test node group creation
	echo "removing kontain-node-initializer"
	- kubectl delete deploy/flaskappkontain
	- kubectl delete daemonset/kontain-node-initializer -n kube-system

	sleep 5

	echo draining and deleting nodegroups from cluster
	- eksctl --cluster kdocscluster-eks drain nodegroup kdocscluster-eks-unmanaged-ng
	- eksctl --cluster kdocscluster-eks delete nodegroup kdocscluster-eks-unmanaged-ng

ekscluster-clean:
	# sometimes this can give an error in cloud formation if stack has not been deleted
	eksctl delete cluster --name kdocscluster-eks --region us-east-1 --wait

	- kubectl config delete-context "kdocscluster-eks"

eks-list-stacks:
	# use this to see if stack exists already because 
	aws cloudformation list-stacks

eks-list-stack-resources:
	aws cloudformation list-stack-resources --stack-name eksctl-kdocscluster-eks-cluster

eks-delete-stack:
	aws cloudformation delete-stack --stack-name eksctl-kdocscluster-eks-cluster

#----------------------
# Kind with KNative
#----------------------
knativekind-install-test: knativecluster-plugins-install knativekindcluster knativekindcluster-apply-km knativekindcluster-test knativekindcluster-clean

knativecluster-plugins-install:
	# ref: https://knative.dev/docs/getting-started/quickstart-install/#install-the-knative-cli
	echo
	echo "installing knative with kind cluster..."
	echo "downloading kn CLI"
	sudo curl -s -Lo /usr/local/bin/kn https://github.com/knative/client/releases/download/knative-v1.4.1/kn-linux-amd64
	sudo chmod +x /usr/local/bin/kn
	sleep 2
	echo
	echo "downloading kn quickstart plugin binary"
	sudo curl -s -Lo /usr/local/bin/kn-quickstart https://github.com/knative-sandbox/kn-plugin-quickstart/releases/download/knative-v1.4.0/kn-quickstart-linux-amd64
	sudo chmod +x /usr/local/bin/kn-quickstart
	sleep 2
	echo
	echo "checking knative quickstart plugin"
	kn quickstart --help
	echo


knativekindcluster:
	echo
	echo starting knative kind cluster...
	kn quickstart kind
	sleep 15
	echo "getting clusters"
	kind get clusters
	echo


knativekindcluster-apply-km:
	echo
	echo "patching configmap/config-features to enable podspec.runtimeclassname for installing KM..."
	kubectl patch configmap/config-features -n knative-serving --type merge -p '{"data":{"kubernetes.podspec-runtimeclassname": "enabled"}}'

	sleep 5
	echo "applying Kontain daemonset yaml..."
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml

	sleep 5

	echo "waiting for kontain-node-initializer to be ready"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 5
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-kind.log

	sleep 20
	kubectl get po -A
	cat /tmp/kontain-node-initializer-kind.log	
	sleep 5


knativekindcluster-test:
	echo
	echo testing the knative kind cluster with Kontain installed
	echo "deploying hello service to cluster..."
	- kn service delete hello-kontain
	# kn service create hello --image gcr.io/knative-samples/helloworld-go --port 8080 --env TARGET=World
	# kn service create hello-kontain --image gcr.io/knative-samples/helloworld-go --port 8080 --env TARGET=World

	sleep 10
	echo "list services"
	kn service list
	# kubectl get svc

	echo
	echo "invoking service"
	echo Accessing URL at: $$(kn service describe hello-kontain -o url)
	curl $$(kn service describe hello-kontain -o url)

	sleep 5
	echo
	echo "deleting service hello-kontain"
	kn service delete hello-kontain

knativekindcluster-clean:
	echo
	echo deleting cluster knative...
	sleep 5
	kind delete clusters knative
	kind get clusters


#----------------------
# kops
#----------------------
# good reference: https://www.patricia-anong.com/blog/2018/8/kubernetes-in-aws-using-kops
# with DNS: https://blog.kubecost.com/blog/kubernetes-kops/
#----------------------
kopscluster-kubectl-configure:
	# kops export kubeconfig kdocs-cluster.k8s.local --admin --state=s3://kontain-kops-state
	kops export kubeconfig ${AWS_KOPS_CLUSTER_NAME} --admin --state=${KOPS_STATE_STORE}

kopscluster-create-s3-store:
	aws  s3api create-bucket --bucket ${KOPS_STATE_STORE_NAME} --region ${AWS_REGION}

kopscluster-config-create:
	echo installing kops cluster config on aws
	
	# create cluster configuration
	kops create cluster \
		--cloud aws \
		${AWS_KOPS_CLUSTER_NAME} \
		--node-count=1 --zones "${AWS_ZONES}"  \
		--authorization RBAC \
		--ssh-public-key ~/.ssh/id_rsa.pub \
		--master-size t2.small \
		--master-volume-size 40 \
		--node-size t3.medium \
		--node-volume-size 80 \
		--image ${AWS_AMI} \
		--state=${KOPS_STATE_STORE}

		# --topology=private \
		# --networking canal or calico \
	
	# verify that state has been created for cluster
	kops get cluster

kopscluster-build:
	echo building the cluster from config

	kops update cluster --name ${AWS_KOPS_CLUSTER_NAME} --yes --state=${KOPS_STATE_STORE}
	# need to export kubeconfig so we can validate without tne "unauthorized" message popping up
	kops export kubeconfig --admin --state=${KOPS_STATE_STORE}

kopscluster-validate:
	kops validate cluster --wait 10m --state=${KOPS_STATE_STORE}
	# kops validate cluster -v10 --logtostderr

kopscluster-apply-kkm:
	echo "applying kkm to kops cluster: kdocscluster-kops"
	# kubectl apply -f kustomize_outputs/kkm.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/kkm.yaml
	sleep 5

	echo "waiting for kontain-node-initializer to be running and applying KKM"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 60
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-gke.log

	sleep 15
	echo "showing output of node-initializer log"
	cat /tmp/kontain-node-initializer-kops.log

kopscluster-clean:
	kops delete cluster ${AWS_KOPS_CLUSTER_NAME} --yes --state=${KOPS_STATE_STORE}

kopscluster-list:
	kops get cluster

kopscluster-edit-ig:
	kops edit instancegroup ${AWS_KOPS_CLUSTER_NAME} ${AWS_KOPS_INSTANCE_GROUP_NAME} --state=${KOPS_STATE_STORE}



#----------------------
# KNative on k8s cluster
#----------------------
knative-apply:
	# ref: https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/#prerequisites

	# 1. Install the required custom resources by running the command:
	echo install knative serving component crds
	kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.4.0/serving-crds.yaml

	# 2. Install the core components of Knative Serving by running the command:
	echo install knative serving core components
	kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.4.0/serving-core.yaml

	# networking layer
	# 1. Install the Knative Kourier controller by running the command:
	echo installing kourier controller
	kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.4.0/kourier.yaml

	# 2. Configure Knative Serving to use Kourier by default by running the command:
	echo configuring knative serving to use Kourier by default
	kubectl patch configmap/config-network \
					--namespace knative-serving \
					--type merge \
					--patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

	kubectl patch configmap/config-features \
		-n knative-serving \
		--type merge \
		-p '{"data":{"kubernetes.podspec-runtimeclassname": "enabled"}}'

	# 3. Fetch the External IP address or CNAME by running the command:
	echo getting external IP or CNAME
	kubectl --namespace kourier-system get service kourier

	# 1. Configure DNS to use Magic DNS (sslip.io) so as not use to curl with Host header
	# Knative provides a Kubernetes Job called default-domain that configures Knative Serving to use sslip.io as the default DNS suffix.
	echo configuring k8s default-domain job to use magic DNS - sslip.io
	kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.4.0/serving-default-domain.yaml

	# 1. verify the install
	echo verifying the install
	kubectl get pods -n knative-serving

knative-dns:
	echo getting public dns/ip for knative/kourier
	kubectl --namespace kourier-system get service kourier

knative-ssl-enablement:
	# ref: https://ruzickap.github.io/k8s-knative-gitlab-harbor/part-06/#enable-automatic-tls-certificate-provisioning-for-knative
	# TODO

knative-test-hello:
	- kn service delete hello
	echo deploying go service hello world
	kn service create hello --image gcr.io/knative-samples/helloworld-go --port 8080 --env TARGET=World

	sleep 5

	echo checking hello service URL:$$(kn service describe hello -o url)
	curl $$(kn service describe hello -o url)

	echo removing hello service
	kn service delete hello

knative-test-hello-kontain:
	- kn service delete hello-kontain
	echo deploying go service hello-kontain
	kn service create hello-kontain --image kontainguide/golang-http-hello:1.0 --port 8080 --env TARGET=World

	sleep 5
	echo checking hello service URL:$$(kn service describe hello -o url)
	curl $$(kn service describe hello-kontain -o url)

	echo removing hello-kontain service
	kn service delete hello-kontain

knative-loadtest-hello-kontain:
	hey -z 30s -c 50 http://hello-kontain.default.44.205.184.10.sslip.io && kubectl get pods

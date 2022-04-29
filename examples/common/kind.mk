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

	sleep 5


kindcluster-clean:
	echo
	echo "deleting kind cluster: kind-kind"
	- kubectl config delete-context "kind-kind"
	kind delete cluster
	sleep 5

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

SHELL :=/bin/bash

# import make targets for kind cluster
include ../../../infra/infra.mk
include ../../../infra/build_args.env

# exports all vars
.EXPORT_ALL_VARIABLES:

# used when wanting to rsync (. hidden) files
#SHELL := bash -O dotglob or extglob
SHELL := /bin/bash

# include environment variables file
ifneq (,$(wildcard ./.env))
    include  .env
    export
endif


.PHONY: build


knativekindcluster-deploy-hello:
	echo
	- kn service delete hello
	echo "deploy hello service for test..."

	kn service create hello \
		--image docker.io/kontainguide/golang-http-hello:1.0 \
		--port 8080 \
		--env TARGET=World

	# kubectl apply -f hello-svc.yml

	sleep 10
	echo "list services"
	kn service list


knativekindcluster-invoke-hello:
	echo
	echo "invoking service"
	echo Accessing URL at: $$(kn service describe hello -o url)
	curl $$(kn service describe hello -o url)


knativekindcluster-update-hello:
	echo
	echo updating service
	kn service update hello --env TARGET=Knative
	# kubectl apply -f ./hello-svc-revised.yml


knativekindcluster-split-traffic:
	echo
	echo updating traffic split 50%
	kn service update hello --traffic hello-00001=50 --traffic @latest=50
	# kubectl apply -f ./hello-svc-traffic-split.yml
	
	echo checking the traffic split by invoking service 10 times
	for i in {1..10}; do curl $$(kn service describe hello -o url)


knativekindcluster-clean-hello:
	echo
	echo "deleting service hello"
	kn service delete hello
	# kubectl delete -f ./hello-svc.yml


knativekindcluster-test-springboot:
	echo
	echo "deploying hello kontain service..."
	kubectl apply -f ./springboothello-kontain.yml

	sleep 10
	echo "list services"
	kn service list
	# kubectl get svc

	echo
	echo "invoking service"
	echo Accessing URL at: $$(kn service describe hello -o url)
	curl $$(kn service describe hello-kontain -o url)

	echo
	echo "deleting service hello"
	# kn service delete hello-kontain
	kubectl delete -f ./springboothello-kontain.yml


knativekindcluster-test-springboot-snap:
	echo
	echo "deploying hello kontain service..."
	kubectl apply -f ./springboothello-kontain-snap.yml

	sleep 10
	echo "list services"
	kn service list
	# kubectl get svc

	echo
	echo "invoking service"
	echo Accessing URL at: $$(kn service describe hello -o url)
	curl $$(kn service describe hello-kontain -o url)

	echo
	echo "deleting service hello"
	# kn service delete hello-kontain
	kubectl delete -f ./springboothello-kontain.yml

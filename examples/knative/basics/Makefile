SHELL :=/bin/bash

# import make targets for kind cluster
include ../../../infra/infra.mk

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

knativekindcluster-up: knativekindcluster knativekindcluster-apply-km

test:
	echo
	echo "deploying hello-kontain service to cluster..."
	- kn service delete hello-kontain
	# kn service create hello --image gcr.io/knative-samples/helloworld-go --port 8080 --env TARGET=World
	# or
	kubectl apply -f ./hello-kontain-svc.yml

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
	# kn service delete hello
	kubectl delete -f ./hello-kontain-svc.yml


deploy-hello-kontain:
	echo
	- kn service delete hello
	echo "deploy hello service for test..."

	# kn service create hello \
	# 	--image docker.io/kontainguide/golang-http-hello:1.0 \
	# 	--port 8080 \
	# 	--env TARGET=World

	kubectl apply -f hello-svc-kontain.yml

	sleep 10
	echo "listing services..."
	kn service list


invoke-hello-kontain:
	echo
	echo "invoking service..."
	echo Accessing URL at: $$(kn service describe hello -o url)
	curl $$(kn service describe hello-kontain -o url)


update-hello-kontain:
	echo
	echo updating service
	# kn service update hello --env TARGET=Knative
	kubectl apply -f ./hello-kontain-svc-revised.yml
	sleep 2
	# kn get revisions list
	echo "getting revisions"
	kubectl get revisions


split-traffic-hello-kontain:
	echo
	echo updating traffic split 50%...
	# kn service update hello --traffic hello-00001=50 --traffic @latest=50
	kubectl apply -f ./hello-kontain-svc-traffic-split.yml

	sleep 2
	echo getting revisions
	kubectl get revisions
	
	sleep 10
	echo
	echo checking the traffic split by invoking service 20 times...
	for i in {1..20}; do curl $$(kn service describe hello-kontain -o url); sleep 1; done


clean-hello-kontain:
	echo
	echo "deleting service hello..."
	kn service delete hello-kontain
	# kubectl delete -f ./hello-svc.yml


test-springboot-hello:
	echo
	echo "deploying hello kontain service..."
	kubectl apply -f ./springboothello-kontain.yml

	sleep 10
	echo "listing services..."
	kn service list
	# kubectl get svc

	sleep 5

	echo
	echo "invoking service..."
	echo Accessing URL at: $$(kn service describe hello-kontain-spring-boot -o url)
	curl $$(kn service describe hello-kontain-spring-boot -o url)


test-springboot-hello-snap:
	echo
	echo "deploying hello kontain service..."
	kubectl apply -f ./springboothello-kontain-snap.yml

	sleep 15
	echo "list services..."
	kn service list
	# kubectl get svc

	echo
	echo "invoking service..."
	echo Accessing URL at: $$(kn service describe hello-kontain-spring-boot-snap -o url)
	curl $$(kn service describe hello-kontain-spring-boot-snap -o url)


springboot-hello-clean:
	echo
	echo "deleting springboot-hello and springboot-hello-snap services..."
	# kn service delete hello-kontain
	kubectl delete -f ./springboothello-kontain.yml
	kubectl delete -f ./springboothello-kontain-snap.yml

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

all: build test push composetest kindcluster kindcluster-apply-km deployk8s testk8s kindcluster-clean clean

IMAGE_NAME="kontainguide/spring-boot-restapi-postgresql"

build:
	echo
	echo "building spring-boot-restapi-postgresql:1.0 image using Jib..."
	mvn clean compile package -Dmaven.test.skip
	docker build -t ${IMAGE_NAME}:1.0 .
	docker tag ${IMAGE_NAME}:1.0 ${IMAGE_NAME}:latest

run:
	# running with compose here as we need the postgresql DB to be up and running as well 
	# mvn spring-boot:run
	# use following to test
	# curl http://localhost:8080/api/v1/products
	docker-compose up


jib-build:
	echo
	echo "building spring-boot-restapi-postgresql with jib..."
	mvn clean compile package jib:build -Djib.to.image=${IMAGE_NAME}:1.0 -Dmaven.test.skip

push:
	docker push ${IMAGE_NAME}:1.0
	docker push ${IMAGE_NAME}:latest
	
test:
	echo "testing spring-boot-restapi-postgresql..."
	- docker stop spring-boot-restapi-postgresql
	docker-compose up -d
	sleep 30
	curl http://localhost:8080/api/v1/products
	echo
	sleep 5
	docker-compose down --remove-orphans
	sleep 10

clean:
	mvn clean
	docker rmi ${IMAGE_NAME}:1.0
	docker rmi ${IMAGE_NAME}:latest

testcompose:
	echo
	echo "running docker-compose"
	docker-compose up -d
	sleep 30
	curl http://localhost:8080/api/v1/products
	echo
	sleep 5
	docker-compose down --remove-orphans
	sleep 5

deployk8s:
	echo
	echo "deploying spring-boot-restapi-postgresql to cluster...assuming with access to postgresql"
	kubectl apply -f k8s.yml
	sleep 10
	kubectl -n default wait pod --for=condition=Ready -l app=spring-boot-restapi-postgresql --timeout=240s
	sleep 5

testk8s:
	echo
	echo "testing spring-boot-restapi-postgresql...assuming with access to postgresql"
	kubectl port-forward svc/spring-boot-restapi-postgresql 8080:8080 2>/dev/null &
	sleep 20
	curl http://localhost:8080/api/v1/products
	echo
	sleep 5
	- pkill -f "port-forward"
	sleep 5
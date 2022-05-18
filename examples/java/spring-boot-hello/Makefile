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

IMAGE_NAME="kontainguide/spring-boot-hello"

build:
	echo
	echo "building spring-boot-hello..."
	mvn clean compile package -Dmaven.test.skip # test
	docker build --build-arg OPEN_JDK_BUILD_VERSION=${OPEN_JDK_BUILD_VERSION} --build-arg OPEN_JDK_KONTAIN_RELEASE_VERSION=${OPEN_JDK_KONTAIN_RELEASE_VERSION}  -t ${IMAGE_NAME}:1.0 .
	docker tag ${IMAGE_NAME}:1.0 ${IMAGE_NAME}:latest

jib-build:
	echo
	echo "building spring-boot-hello with jib..."
	mvn clean compile package jib:build -Djib.to.image=${IMAGE_NAME}:1.0 -Dmaven.test.skip

push:
	docker push ${IMAGE_NAME}:1.0
	docker push ${IMAGE_NAME}:latest
	

test:
	echo "testing spring-boot-hello..."
	- docker stop spring-boot-hello
	docker run -d --rm -p 8080:8080 --runtime=krun --name spring-boot-hello ${IMAGE_NAME}:1.0
	sleep 30
	curl -v http://localhost:8080
	echo
	sleep 5
	docker stop spring-boot-hello
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
	curl -vvv http://localhost:8080
	echo
	sleep 5
	docker-compose down --remove-orphans
	sleep 5

deployk8s:
	echo
	echo "deploying spring-boot-hello to cluster kind..."
	kubectl apply -f k8s.yml
	sleep 10
	kubectl -n default wait pod --for=condition=Ready -l app=spring-boot-hello --timeout=240s
	sleep 5

testk8s:
	echo
	echo "testing spring-boot-hello..."
	kubectl port-forward svc/spring-boot-hello 8080:8080 2>/dev/null &
	sleep 20
	curl -vvv http://localhost:8080
	echo
	sleep 5
	- pkill -f "port-forward"
	sleep 5
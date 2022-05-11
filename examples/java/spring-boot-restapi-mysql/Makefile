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

IMAGE_NAME="kontainguide/spring-boot-tutorials-api-mysql"

build:
	echo
	echo "building spring-boot-restapi-mysql..."
	cd app && mvn clean compile package -Dmaven.test.skip # test
	cd app && docker build -t ${IMAGE_NAME}:1.0 .
	docker tag ${IMAGE_NAME}:1.0 ${IMAGE_NAME}:latest

push:
	docker push ${IMAGE_NAME}:1.0
	docker push ${IMAGE_NAME}:latest

test:
	echo "testing spring-boot-restapi-mysql..."
	- docker-compose down
	docker-compose up -d
	sleep 30
	echo
	echo "adding entries using POST /api/tutorials"
	curl -s -XPOST -H "Content-type:application/json" http://localhost:6868/api/tutorials -d '{"title": "koder tutorial #1", "description": "Tutorial #1 description"}' | jq
	curl -s -XPOST -H "Content-type:application/json" http://localhost:6868/api/tutorials -d '{"title": "koder tutorial #2", "description": "Tutorial #2 description"}' | jq
	echo
	sleep 3
	echo "retrieving entries using GET /api/tutorials"
	curl -s -H "Content-type:application/json" http://localhost:6868/api/tutorials | jq
	echo
	sleep 5
	docker-compose down rm
	sleep 10

clean:
	cd app && pwd && mvn clean
	- docker rmi ${IMAGE_NAME}:1.0
	- docker rmi ${IMAGE_NAME}:latest

testcompose:
	echo
	echo "running docker-compose"
	docker-compose up -d
	sleep 30
	echo "adding entries using POST /api/tutorials"
	curl -s -XPOST -H "Content-type:application/json" http://localhost:6868/api/tutorials -d '{"title": "koder tutorial #1", "description": "Tutorial #1 description"}' | jq
	echo
	echo "retrieving entries using GET /api/tutorials"
	curl -s -XPOST -H "Content-type:application/json" http://localhost:6868/api/tutorials -d '{"title": "koder tutorial #2", "description": "Tutorial #2 description"}' | jq
	echo
	sleep 5
	docker-compose down --remove-orphans
	sleep 5

# deployk8s:
# 	echo
# 	echo "deploying spring-boot-hello to cluster kind..."
# 	kubectl apply -f k8s.yml
# 	sleep 10
# 	kubectl -n default wait pod --for=condition=Ready -l app=spring-boot-hello --timeout=240s
# 	sleep 5

# testk8s:
# 	echo
# 	echo "testing spring-boot-hello..."
# 	kubectl port-forward svc/spring-boot-hello 8080:8080 2>/dev/null &
# 	sleep 20
# 	curl -vvv http://localhost:8080
# 	echo
# 	sleep 5
# 	- pkill -f "port-forward"
# 	sleep 5
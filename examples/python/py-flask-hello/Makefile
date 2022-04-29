SHELL :=/bin/bash

# import make targets for kind cluster
include ../../common/kind.mk
include ../../common/build_args.env

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

all: build test push testcompose kindcluster kindcluster-apply-km deployk8s testk8s kindcluster-clean clean
.PHONY: all

IMAGE_NAME="kontainguide/py-flask-hello"

build:
	echo
	echo "building py-flask-hello..."

	# read the image versions from env file and pass as build args
	docker build --build-arg PYTHON_BUILD_IMAGE_VERSION=${PYTHON_BUILD_IMAGE_VERSION} --build-arg PYTHON_KONTAIN_RELEASE_IMAGE_VERSION=${PYTHON_KONTAIN_RELEASE_IMAGE_VERSION} -t ${IMAGE_NAME}:1.0 .
	docker tag ${IMAGE_NAME}:1.0 ${IMAGE_NAME}:latest

push:
	docker push ${IMAGE_NAME}:1.0
	docker push ${IMAGE_NAME}:latest

test:
	echo "testing py-flask-hello..."
	- docker stop py-flask-hello
	sleep 2
	docker run -d --rm -p 5000:5000 --runtime=krun --name py-flask-hello ${IMAGE_NAME}:1.0
	sleep 15
	curl -v http://localhost:5000
	echo
	sleep 5
	docker stop py-flask-hello
	sleep 5

clean:
	- docker rmi ${IMAGE_NAME}:1.0
	- docker rmi ${IMAGE_NAME}:latest

testcomposeconfig:
	echo 
	echo "running docker-compose config to see what final compose file looks like"
	docker-compose config

testcompose:
	echo
	echo "running docker-compose"
	docker-compose up -d
	sleep 20
	curl -vvv http://localhost:5000
	echo
	sleep 5
	docker-compose down --remove-orphans
	sleep 5

deployk8s:
	echo
	echo "deploying py-flask-hello to cluster kind..."
	kubectl apply -f k8s.yml
	sleep 10
	kubectl -n default wait pod --for=condition=Ready -l app=py-flask-hello --timeout=240s
	sleep 5

testk8s:
	echo
	echo "testing py-flask-hello..."
	- pkill -f "port-forward"
	kubectl port-forward svc/py-flask-hello 5000:5000 2>/dev/null &
	sleep 20
	curl -vvv http://localhost:5000
	echo
	sleep 5
	- pkill -f "port-forward"
	sleep 5

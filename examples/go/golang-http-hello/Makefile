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

all: build test push composetest kindcluster kindcluster-apply-km deployk8s testk8s kindcluster-clean clean
.PHONY: all

build:
	echo
	echo "building go-lang-http-hello..."
	docker build -t kontainguide/golang-http-hello:1.0 .
	docker tag kontainguide/golang-http-hello:1.0 kontainguide/golang-http-hello:latest

push:
	docker push kontainguide/golang-http-hello:1.0
	docker push kontainguide/golang-http-hello:latest

test:
	echo "testing go-lang-http-hello..."
	- docker stop golang-http-hello
	docker run -d --rm -e "PORT=8080" -e "TARGET=Kontain" -p 8080:8080 --runtime=krun --name golang-http-hello kontainguide/golang-http-hello:1.0
	sleep 5
	curl -v http://localhost:8080
	sleep 5
	docker stop golang-http-hello
	sleep 5

clean:
	docker rmi kontainguide/golang-http-hello:1.0

testcompose:
	echo
	echo "running docker-compose"
	docker-compose up -d
	sleep 15
	curl -vvv http://localhost:8080
	sleep 10
	docker-compose down --remove-orphans
	sleep 5

deployk8s:
	echo
	echo "deploying golang-http-hello to cluster kind..."
	kubectl apply -f k8s.yml
	sleep 10
	kubectl -n default wait pod --for=condition=Ready -l app=golang-http-hello --timeout=240s
	sleep 2

testk8s:
	echo
	echo "testing golang-http-hello..."
	kubectl port-forward svc/golang-http-hello 8080:8080 2>/dev/null &
	sleep 15
	curl -vvv http://localhost:8080
	sleep 3
	- pkill -f "port-forward"

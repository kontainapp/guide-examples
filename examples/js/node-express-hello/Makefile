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

all: build test testcompose kindcluster kindcluster-apply-km deployk8s testk8s kindcluster-clean clean
.PHONY: all

build:
	echo
	echo "building node-express-hello..."
	docker build -t kontainguide/node-express-hello:1.0 .
	docker tag kontainguide/node-express-hello:1.0 kontainguide/node-express-hello:latest

push:
	docker push kontainguide/node-express-hello:1.0
	docker push kontainguide/node-express-hello:latest


test:
	echo "testing node-express-hello..."
	- docker stop node-express-hello
	docker run -d --rm -p 8080:8080 --runtime=krun --name node-express-hello kontainguide/node-express-hello:1.0
	sleep 10
	curl -v http://localhost:8080
	sleep 5
	docker stop node-express-hello
	sleep 5

clean:
	docker rmi kontainguide/node-express-hello:1.0

testcompose:
	echo
	echo "running docker-compose"
	docker-compose up -d
	sleep 10
	curl -vvv http://localhost:8080
	sleep 5
	docker-compose down --remove-orphans
	sleep 5

deployk8s:
	echo
	echo "deploying node-express-hello to cluster kind..."
	kubectl apply -f k8s.yml
	sleep 10
	kubectl -n default wait pod --for=condition=Ready -l app=node-express-hello --timeout=240s
	sleep 5

testk8s:
	echo
	echo "testing node-express-hello..."
	kubectl port-forward svc/node-express-hello 8080:8080 2>/dev/null &
	sleep 15
	curl -vvv http://localhost:8080
	sleep 5
	- pkill -f "port-forward"
	sleep 5
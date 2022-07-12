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

all: build test testcompose kindcluster kindcluster-apply-km deployk8s testk8s kindcluster-clean clean

build:
	echo
	echo "building node-hello-world..."
	docker build -t kontainguide/node-hello-world:1.0 .
	docker tag kontainguide/node-hello-world:1.0 kontainguide/node-hello-world:latest

push:
	docker push kontainguide/node-hello-world:1.0
	docker push kontainguide/node-hello-world:latest


test:
	echo "testing node-hello-world..."
	- docker stop node-hello-world
	docker run -d --rm -p 3000:3000 --runtime=krun --name node-hello-world kontainguide/node-hello-world:1.0
	sleep 10
	curl -v http://localhost:3000
	sleep 5
	docker stop node-hello-world
	sleep 5

clean:
	docker rmi kontainguide/node-hello-world:1.0


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
	echo "deploying node-hello-world to cluster kind..."
	kubectl apply -f k8s.yml
	sleep 10
	kubectl -n default wait pod --for=condition=Ready -l app=node-hello-world --timeout=240s
	sleep 5

testk8s:
	echo
	echo "testing node-hello-world..."
	kubectl port-forward svc/node-hello-world 3000:3000 2>/dev/null &
	sleep 15
	curl -vvv http://localhost:3000
	sleep 5
	- pkill -f "port-forward"
	sleep 5

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

all: build test push composetest kindcluster kindcluster-apply-km deployk8s testk8s kindcluster-clean clean
.PHONY: all

IMAGE_NAME=kontainguide/insta-start-spring-boot

build:
	echo
	echo "building spring-boot-hello..."
	mvn clean compile package -Dmaven.test.skip # test
	docker build -t ${IMAGE_NAME}:1.0 .
	docker tag ${IMAGE_NAME}:1.0 ${IMAGE_NAME}:latest


push:
	docker push ${IMAGE_NAME}:1.0
	docker push ${IMAGE_NAME}:latest
	docker push ${IMAGE_NAME}-snap:1.0
	docker push ${IMAGE_NAME}-snap:latest

run:
	docker run --runtime=krun --name=KM_instaspringboothello -p 8080:8080 -v /opt/kontain/bin/km_cli:/opt/kontain/bin/km_cli -v $(pwd):/mnt:rw ${IMAGE_NAME}

snapshot:
	- docker stop KM_instaspringboothello
	- docker rm KM_instaspringboothello
	docker run -d --runtime=krun --name=KM_instaspringboothello -p 8080:8080 -v /opt/kontain/bin/km_cli:/opt/kontain/bin/km_cli -v $(pwd):/mnt:rw ${IMAGE_NAME}
	sleep 30
	docker exec KM_instaspringboothello /opt/kontain/bin/km_cli -s /tmp/km.sock
	sleep 5
	docker cp KM_instaspringboothello:/opt/src/app/kmsnap .
	sleep 5
	docker rm KM_instaspringboothello
	chmod +x kmsnap
	docker build -t ${IMAGE_NAME}-snap:1.0 -f Dockerfile.snap .
	docker tag ${IMAGE_NAME}-snap:1.0 ${IMAGE_NAME}-snap:latest


runsnapshot:
	docker run --runtime=krun --rm -it --name=KM_instaspringboothello_snap -p 8080:8080 ${IMAGE_NAME}-snap

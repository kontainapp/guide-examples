SHELL :=/bin/bash

.PHONY: build


IMAGE_NAME="kontainguide/py-students-api"

build:
	echo
	echo "building py-students-api..."

	# read the image versions from env file and pass as build args
	docker build -t ${IMAGE_NAME}:1.0 .
	docker tag ${IMAGE_NAME}:1.0 ${IMAGE_NAME}:latest

push:
	docker push ${IMAGE_NAME}:1.0
	docker push ${IMAGE_NAME}:latest

test:
	echo "testing py-students-api..."
	- docker stop py-students-api
	- docker rm py-students-api
	sleep 2
	docker run -d --rm -p 5000:5000 --runtime=krun --name py-students-api ${IMAGE_NAME}:1.0
	sleep 15
	curl http://localhost:5000/students/
	echo
	sleep 5
	docker stop py-students-api
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
	echo "deploying py-students-api to cluster kind..."
	kubectl apply -f k8s.yml
	sleep 10
	kubectl -n default wait pod --for=condition=Ready -l app=py-students-api --timeout=240s
	sleep 5

testk8s:
	echo
	echo "testing py-students-api..."
	- pkill -f "port-forward"
	kubectl port-forward svc/py-students-api 5000:5000 2>/dev/null &
	sleep 20
	curl -vvv http://localhost:5000
	echo
	sleep 5
	- pkill -f "port-forward"
	sleep 5

.PHONY: build push test

all:

build:
	echo
	echo "building blog-posts-api..."
	docker build -t kontainguide/blog-posts-api:1.0 .
	docker tag kontainguide/blog-posts-api:1.0 kontainguide/blog-posts-api:latest

push:
	docker push kontainguide/blog-posts-api:1.0
	docker push kontainguide/blog-posts-api:latest


test:
	echo "testing blog-posts-api..."
	- docker stop blog-posts-api
	docker run -d --rm -p 8080:8080 --runtime=krun --name blog-posts-api kontainguide/blog-posts-api:1.0
	sleep 10
	curl -v http://localhost:8080/posts
	sleep 5
	docker stop blog-posts-api
	sleep 5

clean:
	docker rmi kontainguide/blog-posts-api:1.0

testcompose:
	echo
	echo "running docker-compose"
	docker-compose up -d
	sleep 10
	curl -v http://localhost:8080/posts
	sleep 5
	docker-compose down --remove-orphans
	sleep 5

deployk8s:
	echo
	echo "deploying blog-posts-api to cluster kind..."
	kubectl apply -f k8s.yml
	sleep 10
	kubectl -n default wait pod --for=condition=Ready -l app=blog-posts-api --timeout=240s
	sleep 5

testk8s:
	echo
	echo "testing blog-posts-api..."
	kubectl port-forward svc/blog-posts-api 8080:8080 2>/dev/null &
	sleep 15
	curl -v http://localhost:8080/posts
	sleep 5
	- pkill -f "port-forward"
	sleep 5
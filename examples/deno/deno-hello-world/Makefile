build:
	echo
	echo "building deno-hello-world..."
	docker build -t kontainguide/deno-hello-world:1.0 .
	docker tag kontainguide/deno-hello-world:1.0 kontainguide/deno-hello-world:latest

push:
	docker push kontainguide/deno-hello-world:1.0
	docker push kontainguide/deno-hello-world:latest

test:
	echo "testing deno-hello-world..."
	- docker stop deno-hello-world
	docker run -d --rm -p 8000:8000 --runtime=krun --name deno-hello-world kontainguide/deno-hello-world:1.0
	sleep 10
	curl -v http://localhost:8000
	sleep 5
	docker stop deno-hello-world
	sleep 5

clean:
	docker rmi kontainguide/deno-hello-world:1.0


testcompose:
	echo
	echo "running docker-compose"
	docker-compose up -d
	sleep 10
	curl -vvv http://localhost:8000
	sleep 5
	docker-compose down --remove-orphans
	sleep 5

deployk8s:
	echo
	echo "deploying deno-hello-world to cluster kind..."
	kubectl apply -f k8s.yml
	sleep 10
	kubectl -n default wait pod --for=condition=Ready -l app=deno-hello-world --timeout=240s
	sleep 5

testk8s:
	echo
	echo "testing deno-hello-world..."
	kubectl port-forward svc/deno-hello-world 8000:8000 2>/dev/null &
	sleep 15
	curl -vvv http://localhost:8000
	sleep 5
	- pkill -f "port-forward"
	sleep 5

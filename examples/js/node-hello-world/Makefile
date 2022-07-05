build:
	docker build -t kontainguide/node-hello-world .

run:
	docker run --runtime=krun -p 3000:3000 kontainguide/node-hello-world:latest

push:
	docker tag kontainguide/node-hello-world:latest kontainguide/node-hello-world:1.0
	docker push kontainguide/node-hello-world:latest
	docker push kontainguide/node-hello-world:1.0

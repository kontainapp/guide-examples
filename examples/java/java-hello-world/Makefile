build:
	docker build -t kontainguide/java-hello-world:latest .

run:
	docker run --runtime=krun kontainguide/java-hello-world:latest

push:
	docker tag kontainguide/java-hello-world:latest kontainguide/java-hello-world:1.0
	docker push kontainguide/java-hello-world:latest
	docker push kontainguide/java-hello-world:1.0

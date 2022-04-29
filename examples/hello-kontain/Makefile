build:
	docker build -t kontainguide/hello-kontain:1.0 .
	docker tag kontainguide/hello-kontain:1.0 kontainguide/hello-kontain:latest

push:
	docker push kontainguide/hello-kontain:latest
	docker push kontainguide/hello-kontain:1.0

test:
	docker run --rm --runtime=krun --rm kontainguide/hello-kontain

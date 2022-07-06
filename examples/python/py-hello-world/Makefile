build:
	docker build -t kontainguide/py-hello-world .

run:
	docker run --runtime=krun -p 8000:8000 kontainguide/py-hello-world

push:
	docker tag kontainguide/py-hello-world:latest kontainguide/py-hello-world:1.0
	docker push kontainguide/py-hello-world:latest
	docker push kontainguide/py-hello-world:1.0
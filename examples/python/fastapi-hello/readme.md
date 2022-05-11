# to build this example
```bash
$ docker build --build-arg PYTHON_BUILD_IMAGE_VERSION=python:3.9-slim --build-arg PYTHON_KONTAIN_RELEASE_IMAGE_VERSION=kontainapp/runenv-python-3.9:latest -t kontainguide/fastapi-hello:1.0 .
```

# to run this example
```bash
$ docker run -d --rm -p 5000:5000 --runtime=krun --name fastapi-hello kontainguide/fastapi-hello:1.0
```

# invoke the service
$ curl -v http://localhost:5000

$ docker stop fastapi-hello
```

# to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl -v http://localhost:5000

# shut down compose
$ docker-compose down
```

# to run this example kubernetes
```bash
$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/fastapi-hello 5000:5000 2>/dev/null &

# invoke the service
$ curl -vvv http://localhost:8080

# kill the port-forward
$ pkill -f "port-forward"
```

# reference
[https://fastapi.tiangolo.com/deployment/docker/](https://fastapi.tiangolo.com/deployment/docker/)

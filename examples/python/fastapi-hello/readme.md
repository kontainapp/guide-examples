# Description
This example shows how to build, push, run a Python FastAPI based app in Docker and Kubernetes with Kontain as the runtime.

The difference between this and the Flask API based example is that we run the Docker image as is without any conversion to Kontain based containers, but yet provide a secure environment.  Thus this does not reduce the size but enables the convenience of using current containers as-is without any changes.

# to build this example
```bash
$ docker build -t kontainguide/fastapi-hello:1.0 .
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

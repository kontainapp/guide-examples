# Description
This is a golang-based example of using Kontain to build, push, run a secure Kontain container in Docker and Kubernetes.

# to build this example
```bash
$ docker build -t kontainguide/golang-http-hello:1.0 .
```

# see image sizes
```bash
$ docker images|grep golang
kontainguide/golang-http-hello  1.0      1071c7cf9d97   37 minutes ago      6.24MB
kontainguide/golang-http-hello  latest   1071c7cf9d97   37 minutes ago      6.24MB
golang                          latest   65375c930b21   8 days ago          964MB
```

**Note that the kontainguide/golang-http-hello image is 6.2MB whereas the base golang imageis 964MB.**

# to run this example
```bash
$ docker run -d --rm -e "PORT=8080" -e "TARGET=Kontain" -p 8080:8080 --runtime=krun --name golang-http-hello kontainguide/golang-http-hello:1.0

# invoke the service
$ curl -v http://localhost:8080

# stop the service
$ docker stop golang-http-hello
```

# to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl -v http://localhost:8080

# stop compose
$ docker-compose down
```

# to run this example in kubernetes
```bash

$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/golang-http-hello 8080:8080 2>/dev/null &

# invoke the service
$ curl -vvv http://localhost:8080

# kill the port-forward
$ pkill -f "port-forward"
```
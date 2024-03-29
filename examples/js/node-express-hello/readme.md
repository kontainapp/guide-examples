# Description
This example shows how to build, push, run a NodeJS based app in a Kontain container in Docker and Kubernetes.

# to build this example
```bash
$ docker build -t kontainguide/node-express-hello:1.0 .
```

# see image sizes
```bash
# just for comparison purposes, build the docker-based image as well
$ docker build -f Dockerfile.docker -t kontainguide/node-express-hello-docker .

# now see image sizes
$ docker images | grep -E 'node|express'
...
...
kontainguide/node-express-hello-docker latest   922MB
kontainguide/node-express-hello        1.0      84.2MB
kontainguide/node-express-hello        latest   84.2MB
kontainapp/runenv-node                 latest   81.3MB
node                                   12       918MB
...
...
```

**Please note that the image size for the Kontain based container is 84.2MB versus the base container being 918MB**

# to run this example
```bash
$ docker run -d --rm -p 8080:8080 --runtime=krun --name node-express-hello kontainguide/node-express-hello:1.0

# invoke the service
$ curl -v http://localhost:8080
{"message":"Hello from Kontain!"}

$ docker stop node-express-hello
```

# to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl -v http://localhost:8080
{"message":"Hello from Kontain!"}

# shut down compose
$ docker-compose down
```

# to run this example in kubernetes
```bash
$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/node-express-hello 8080:8080 2>/dev/null &

# invoke the service
$ curl -v http://localhost:8080
{"message":"Hello from Kontain!"}

# kill the port-forward
$ pkill -f "port-forward"
```
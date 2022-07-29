
# Quick start
Once you have installed Kontain, and cloned the examples repository, and you are ready to try things out, below are a few quick tips to try out Kontain in Docker, docker-compose and Kubernetes.

## Using Kontain with Docker hello-world:
### run the classic docker hello-world program with Kontain as the runtime

```shell
$ docker run --runtime=krun hello-world
....

# this verifies that the local Docker runtime is configured with Kontain as an alternate runtime to Containerd as configured in:
$ cat /etc/docker/daemon.json
{
  "runtimes": {
    "krun": {
      "path": "/opt/kontain/bin/krun"
    }
  }
}
```

### Try Kontain with building and running a golang example

```shell
$ cd ~/guide-examples/examples/go/golang-http-hello/

# build
$ docker build -t kontainguide/golang-http-hello:1.0 .

# run
$ docker run -d --rm -p 8080:8080 --runtime=krun --name golang-http-hello kontainguide/golang-http-hello:1.0

# verify its running
$ docker ps

# invoke the service
$ curl  http://localhost:8080

# stop the service
$ docker stop golang-http-hello
```

### Try out Kontain with docker-compose

```shell
$ cd ~/guide-examples/examples/go/golang-http-hello/

# see kontain integration with the runtime:krun line in the compose manifest
$ cat docker-compose.yml

# run with docker-compose
$ docker-compose up -d

# invoke the service
$ curl  http://localhost:8080

# stop the service
$ docker-compose down
```

### Try using Kontain in Kubernetes

```shell
$ cd ~/guide-examples/examples/go/golang-http-hello/

$ kubectl apply -f k8s.yml

# verify that the pod is running
$ kubectl get po

# port-forward the service to verify that the pod can service traffic
$ kubectl port-forward svc/golang-http-hello 8080:8080 2>/dev/null &

# invoke the service
$ curl http://localhost:8080

# kill the port-forwarding
$ pkill -f “port-forward”

# delete the service from kubernetes
$ kubectl delete -f k8s.yml
```
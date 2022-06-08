# Description
This is a golang-based example of using Kontain to build, push, run a secure Kontain container in Docker and Kubernetes.
It also serves as a utility to determine whether or not the kontain runtime is properly installed and running.

When an HTTP get request is received, this program executes a `uname(2)` syscall and return a JSON encoded string with the
results.  When a process is run under the control of the Kontain hypervisor (KM), the uname `release` field will have the string
"`.kontain.KVM`" or "`.kontain.KKM`" appended to the Linux release string. Which of the two strings is determined by which
virtualization driver is used. This is used to determine whether KM is in control or not in some tests and demos.

# to build this example
```bash
$ docker build -t kontainguide/kontain-http-uname:1.0 .
```

# see image sizes
```bash
$ docker images|grep uname
kontainguide/kontain-http-uname  1.0      1071c7cf9d97   37 minutes ago      6.24MB
kontainguide/kontain-http-uname  latest   1071c7cf9d97   37 minutes ago      6.24MB
```

# to run this example
```bash
$ docker run -d --rm -e "PORT=8080" -e "TARGET=Kontain" -p 8080:8080 --runtime=krun --name kontain-http-uname kontainguide/kontain-http-uname:1.0

# invoke the service
$ curl -v http://localhost:8080

# stop the service
$ docker stop kontain-http-uname
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
$ kubectl port-forward svc/kontain-http-uname 8080:8080 2>/dev/null &

# invoke the service
$ curl -vvv http://localhost:8080

# kill the port-forward
$ pkill -f "port-forward"
```

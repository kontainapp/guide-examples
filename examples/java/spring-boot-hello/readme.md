# Description
This shows how to create, build, push and run a simple Spring Boot based Container with Kontain in Docker and Kubernetes.

# to build this example
```bash
$ mvn clean compile package -Dmaven.test.skip
$ docker build -t kontainguide/spring-boot-hello:1.0 .
```

Out of curiousity to see image sizes, let's build the plain Docker image:
```bash
$ docker build -t kontainguide/spring-boot-hello-docker:1.0 -f Dockerfile.docker .
```

# see image sizes
```bash
$ docker images | grep -E 'spring|jdk'
...
openjdk                                11-jdk-slim-buster  422MB
kontainapp/runenv-jdk-shell-11.0.8     latest              179MB
kontainguide/spring-boot-hello         1.0                 197MB
kontainguide/spring-boot-hello-docker  1.0                 439MB
...
```

**Please note the image size of the base container at 439MB and that of the Kontain container at 197MB.**

# to run this example
```bash
$ docker run -d --rm -p 8080:8080 --runtime=krun --name spring-boot-hello kontainguide/spring-boot-hello:1.0

# invoke the service
$ curl http://localhost:8080
Hello from Kontain!

$ docker stop spring-boot-hello
```

# to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl -v http://localhost:8080

# shut down compose
$ docker-compose down
```

# to run this example in kubernetes
```bash
$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/spring-boot-hello 8080:8080 2>/dev/null &

# invoke the service
$ curl -vvv http://localhost:8080

# kill the port-forward
$ pkill -f "port-forward"
```

# NOTE for using JIB based builds
To use jib-based build for the same image you can do:
```shell
$ make jib-build
```
this creates a docker image named “kontainguide/spring-boot-hello:1.0” not using “docker build…” steps but using the maven Jib plugin-based build.

Note that it DOES NOT use a Dockerfile - just builds Docker image by itself using internal APIs

To run this using Kontain you can use:
$ docker run -p8080:8080 --runtime=krun kontainguide/spring-boot-hello:1.0

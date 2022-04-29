# to build this example
```bash
$ docker build --build-arg OPEN_JDK_BUILD_VERSION=openjdk:11-jdk-slim-buster --build-arg OPEN_JDK_KONTAIN_RELEASE_VERSION=kontainapp/runenv-jdk-shell-11.0.8:latest -t kontainguide/spring-boot-hello:1.0 .
```

# see image sizes
```bash
$ docker images | grep -E 'spring|jdk'
...
openjdk                            11-jdk-slim-buster  422MB
kontainapp/runenv-jdk-shell-11.0.8 latest              179MB
kontainguide/spring-boot-hello     1.0                 197MB
...
```

# to run this example
```bash
$ docker run -d --rm -p 8080:8080 --runtime=krun --name spring-boot-hello kontainguide/spring-boot-hello:1.0

# invoke the service
$ curl -v http://localhost:8080

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
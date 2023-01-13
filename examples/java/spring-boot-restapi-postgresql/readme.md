# Description
This shows how to create, build, push and run a simple Spring Boot based Container with Kontain in Docker and Kubernetes.

# to build this example
```bash
$ mvn clean compile package -Dmaven.test.skip
$ docker build -t kontainguide/spring-boot-restapi-postgresql:1.0 .
```

Out of curiousity to see image sizes, let's build the plain Docker image:
```bash
$ docker build -t kontainguide/spring-boot-restapi-postgresql-docker:1.0 -f Dockerfile.docker .
```

# see image sizes
```bash
$ docker images | grep -E 'postgres|jdk'
...
openjdk                                11-jdk-slim-buster  422MB
kontainapp/runenv-jdk-shell-11.0.8     latest              179MB
kontainguide/spring-boot-restapi-postgresql         1.0                 228MB
kontainguide/spring-boot-restapi-postgresql-docker  1.0                 702MB
...

```

**Please note the image size of the base container at 702MB and that of the Kontain container at 228MB.**

# to run this example
```bash
# in terminal 1 (Ctrl-C to stop)
$ docker-compose up

# invoke the service in another terminal
$ curl http://localhost:8080/api/v1/products
[{"id":1,"name":"Skates","quantity":10,"price":1000.0},{"id":2,"name":"Skiis","quantity":20,"price":2000.0},{"id":3,"name":"Tennis Racquet","quantity":30,"price":3000.0},{"id":3,"name":"Shoes","quantity":40,"price":4000.0},{"id":3,"name":"Socks","quantity":50,"price":5000.0},{"id":3,"name":"Trees","quantity":60,"price":6000.0},{"id":3,"name":"Plants","quantity":70,"price":7000.0},{"id":3,"name":"PCs","quantity":80,"price":8000.0},{"id":3,"name":"Hoses","quantity":90,"price":9000.0},{"id":3,"name":"Tables","quantity":10,"price":1000.0},{"id":3,"name":"Chairs","quantity":20,"price":2000.0},{"id":3,"name":"TVs","quantity":30,"price":3000.0},{"id":3,"name":"Couches","quantity":40,"price":4000.0},{"id":3,"name":"Carpets","quantity":50,"price":5000.0}]
```

# to run the Spring Boot image in kubernetes (assuming you give it access to PostgresQL running outside of Kubernetes)
```bash
$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/spring-boot-hello 8080:8080 2>/dev/null &

# invoke the service
$ curl http://localhost:8080/api/v1/products

# to kill the port-forward
$ pkill -f "port-forward"
```

# reference
An example sourced from this blog:
https://betulsahinn.medium.com/dockerizing-a-spring-boot-application-and-using-the-jib-maven-plugin-95c329866f34

with source:
https://github.com/betul-sahin/springboot-docker-maven-jib-plugin
# Description
This is a Deno Typescript based example of using Kontain to build, push, run a secure Kontain container in Docker and Kubernetes.

# Dockerfile
Below we show the simple Dockerfile that was used to create the image

```shell
FROM denoland/deno:1.23.3 as base
WORKDIR /app
COPY . ./
RUN deno cache server.ts
EXPOSE 8000
CMD ["deno", "run", "--allow-net", "server.ts"]
```

# to build this example
```bash
$ docker build -t kontainguide/deno-hello-world:1.0 .
```

# to run this example
```bash
$ docker run -d --rm -e "PORT=8000" -p 8000:8000 --runtime=krun --name deno-hello-world kontainguide/deno-hello-world:1.0

# invoke the service
$ curl -v http://localhost:8000
Hello world from Deno!

# stop the service
$ docker stop deno-hello-world
```

# to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl -v http://localhost:8000
Hello world from Deno!

# stop compose
$ docker-compose down
```

# to run this example in kubernetes
```bash

$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/deno-hello-world 8000:8000 2>/dev/null &

# invoke the service
$ curl -vvv http://localhost:8000
Hello world from Deno!

# kill the port-forward
$ pkill -f "port-forward"
```
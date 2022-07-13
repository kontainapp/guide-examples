# Description
This example shows how to build a Deno-based Typescript application using a Dockerfile and run it in Kontain.  This example uses Deno.

```shell
# build the example
$ docker build -t kontainguide/node-hello-world .

# run the example using Kontain
$ docker run --runtime=krun -p 3000:3000 kontainguide/node-hello-world
Hello world from Kontain!

# optional - to push to docker registry
$ docker push <your-repository/your-image>:<your-image-version>
```

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
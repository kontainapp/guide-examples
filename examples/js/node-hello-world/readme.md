# Description
This example shows how to build a Javascript NodeJS application using a Dockerfile and run it in Kontain.  This example uses Node 14.


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
FROM node:14
WORKDIR /usr/src/app
COPY . .
RUN npm init -y
EXPOSE 3000
CMD ["node", "app.js"]
```
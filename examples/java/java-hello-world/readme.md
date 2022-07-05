# Description
This example shows how to build a Java hello world example using a Dockerfile and run it in Kontain.  This example leverages OpenJDK 11.


```shell
# to build the example
$ docker build -t kontainguide/java-hello-world:latest

# to run the example using Kontain
$ docker run --runtime=krun kontainguide/java-hello-world:latest
Hello world from Kontain!

# optional - to push to docker registry
$ docker push <your-repository/your-image>:<your-image-version>
```

# Dockerfile
Below we show the simple Dockerfile that was used to create the image

```shell
FROM openjdk:11
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Hello.java
CMD ["java", "Hello"]
```
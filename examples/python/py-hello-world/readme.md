# Description
This example shows how to build a simple Python http service in Docker and run it with Kontain.

```shell
# build the example
$ docker build -t kontainguide/py-hello-world .

# run the example using Kontain
$ docker run --runtime=krun -p 8000:8000 kontainguide/py-hello-world
Hello world from Kontain!

# optional - to push to docker registry
$ docker push <your-repository/your-image>:<your-image-version>
```

# Dockerfile
Below we show the simple Dockerfile that was used to create the image

```shell
FROM python:3.9
WORKDIR /code
COPY . .
EXPOSE 8000
CMD ["python", "helloservice.py"]
```
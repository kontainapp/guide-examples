# to build this example
```bash
$ docker build --build-arg PYTHON_BUILD_IMAGE_VERSION=python:3.9-slim --build-arg PYTHON_KONTAIN_RELEASE_IMAGE_VERSION=kontainapp/runenv-python-3.9:latest -t kontainguide/py-flask-hello:1.0 .
```

# see image sizes
```bash
$ docker images|grep python
kontainapp/runenv-python-3.9 latest               793bfa36a196   2 days ago          24.1MB
python                       3.8-slim             5ce3cfb9de89   8 days ago          124MB
python                       3.9-slim             8c7051081f58   8 days ago          125MB
kontainapp/runenv-python-3.8 v0.9.1               aee035a4b2bc   7 months ago        23.5MB
```

# to run this example
```bash
$ docker run -d --rm -p 5000:5000 --runtime=krun --name py-flask-hello kontainguide/py-flask-hello:1.0
```

# invoke the service
$ curl -v http://localhost:5000

$ docker stop py-flask-hello
```

# to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl -v http://localhost:5000

# shut down compose
$ docker-compose down
```

# to run this example kubernetes
```bash
$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/py-flask-hello 5000:5000 2>/dev/null &

# invoke the service
$ curl -vvv http://localhost:8080

# kill the port-forward
$ pkill -f "port-forward"
```
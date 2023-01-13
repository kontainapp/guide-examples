# Description
This example shows how to build, push, run a Python Flask based app in a Kontain container in Docker and Kubernetes.

# to build this example
```bash
$ docker build -t kontainguide/py-students-api:1.0 .

# lets build the docker-based image as well to compare sizes
$ docker build -f Dockerfile.docker -t kontainguide/py-students-api-docker:1.0 .
```

# see image sizes
```bash
$ docker images|grep -E 'python|py-students-api'
kontainguide/py-students-api-docker       148MB
kontainguide/py-students-api              44.1MB
python                                   124MB
kontainapp/runenv-python-3.9             24.1MB
```

**Please note that the Kontain based container is 23.5MB in size versus the "Slim" python-slim base container**

# to run this example
```bash
$ docker run -d --rm -p 5000:5000 --runtime=krun --name py-students-api kontainguide/py-students-api:1.0

# invoke the service
$ curl -v http://localhost:5000/students/

$ docker stop py-students-api
```

# to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl http://localhost:5000/students/

# shut down compose
$ docker-compose down
```

# to run this example kubernetes
```bash
$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/py-students-api 5000:5000 2>/dev/null &

# invoke the service
$ curl http://localhost:5000/students/

# kill the port-forward
$ pkill -f "port-forward"
```

# ref
Example referenced from here: 
https://medium.com/@poojasanika01/create-simple-python-web-api-s-using-flask-b011e0eb7b1a


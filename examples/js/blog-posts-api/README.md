# Description
This example shows how to build, push, run a NodeJS based app in a Kontain container in Docker and Kubernetes.

# to build this example
```bash
$ docker build -t kontainguide/node-blog-posts-api:1.0 .
```

# see image sizes
```bash
# just for comparison purposes, build the docker-based image as well
$ docker build -f Dockerfile.docker -t kontainguide/kontainguide/node-blog-posts-api-docker .

# now see image sizes
$ docker images | grep -E 'node|blog'
...
...
kontainguide/node-blog-posts-api-docker latest   922MB
kontainguide/node-blog-posts-api        1.0      84.2MB
kontainguide/node-blog-posts-api        latest   84.2MB
kontainapp/runenv-node                 latest   81.3MB
node                                   12       918MB
...
...
```

**Please note that the image size for the Kontain based container is 84.2MB versus the base container being 918MB**

# to run this example
```bash
$ docker run -d --rm -p 8080:8080 --runtime=krun --name node-blog-posts-api kontainguide/node-blog-posts-api:1.0

# Add a post to the blog service
$ curl -H "Content-Type: application/json" -X POST -d '{"name": "My first article", "url":"http://example.com", "text": ""}'  http://localhost:8080/posts
{"id":4}

# get the blog posts
$ curl http://localhost:8080/posts

$ docker stop node-blog-posts-api
```

# to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl -v http://localhost:8080
{"message":"Hello from Kontain!"}

# shut down compose
$ docker-compose down
```

# to run this example in kubernetes
```bash
$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/node-blog-posts-api 8080:8080 2>/dev/null &

# invoke the service
$ curl -v http://localhost:8080/posts

# kill the port-forward
$ pkill -f "port-forward"
```

# Reference
This example was sourced from the below

# restful-api-without-db
## Example of RESTful API for a Blog without a DB using Node.js
```shell
# To run it:
git clone https://github.com/rozzilla/restful-api-without-db.git && cd restful-api-without-db && npm install && npm start

# To try it, use an HTTP agent or tester (like CURL).

# Request examples:
### Posts post data
curl -H "Content-Type: application/json" -X POST -d '{"name": "My first article", "url":"http://example.com", "text": ""}'  "http://localhost:8080/posts"

### Updates post data at specific id
curl -H 'Content-Type: application/json' -X PUT -d '{"name": "Updated article", "url":"https://www.google.com", "text": ""}' "http://localhost:8080/posts/1"

### Gets post data
curl "http://localhost:8080/posts"

### Deletes post data at specific id
curl -X DELETE "http://localhost:8080/posts/2"

### Posts comment
curl -H "Content-Type: application/json" -X POST -d '{"text": "NEW COMMENT added!!!"}'  "http://localhost:8080/posts/0/comments"

### Updates comment at specific id
curl -H "Content-Type: application/json" -X PUT -d '{"text": "UPDATED comment!!!"}'  "http://localhost:8080/posts/0/comments/1"

### Gets all comments
curl "http://localhost:8080/posts/0/comments"

### Deletes comment at specific id
curl -X DELETE "http://localhost:8080/posts/0/comments/1"
```

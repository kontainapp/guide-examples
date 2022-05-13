# Description
This is a an easy way to test running a kontain based container.

# to build image
```bash
make build
...
Successfully tagged kontainguide/hello-kontain:1.0
docker tag kontainguide/hello-kontain:1.0 kontainguide/hello-kontain:latest
```

# to push to docker
```bash
make push
```

# to run
```bash
make run
docker run --rm --runtime=krun --rm kontainguide/hello-kontain
Hello, world
Hello, argv[0] = '/hello_test.km'
Hello, argv[1] = 'from'
Hello, argv[2] = 'docker'
```
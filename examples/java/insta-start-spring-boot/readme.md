# Description
This example shows how to use Kontain to create an instantly starting Sping Boot Kontain based container.

This allows you to instantly start up a container without having to wait a few seconds.

# to experience the speed of the "Instantly starting" Spring Boot Container snap example
to run the regular spring boot image in docker and check its output that is available after about 5-8 seconds
```shell
# in terminal 1
$ docker run --runtime=krun -p 8080:8080 kontainguide/insta-start-spring-boot

# in terminal 2
$ curl http://localhost:8080
```

to run the "Instantly starting" snapshot spring boot image in docker and check its output that's available in milliseconds
```shell
# in terminal 1
$ docker run --runtime=krun -p 8080:8080 kontainguide/insta-start-spring-boot-snap

# in terminal 2
$ curl http://localhost:8080
```
# build
## to build the Inststart Snapshot Container of this Spring boot Container
```bash
# In terminal 1 do:
$ make build
$ make run-for-snap

# in terminal 2 do:
$ make snapshot
```

This creates an Instastart Snapshot container of the application.

## to run and experience the "Instantly starting" Spring Boot Container
```bash
# in terminal 1
$ make run-snapshot

# in terminal 2 do this immediately
# invoke the service 
$ curl -v http://localhost:8080
```

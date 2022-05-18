# Description
This example shows how to use Kontain to create an instantly starting Sping Boot Kontain based container.

This allows you to instantly start up a container without having to wait a few seconds.

# to build the Inststart Snapshot Container of this Spring boot Container
```bash
# In terminal 1 do:
$ make build
$ make run

# in terminal 2 do:
$ make snapshot
```

This creates an Instastart Snapshot container of the application

# to run and experience the "Instantly starting" Spring Boot Container
```bash
# in terminal 1
$ make runsnapshot

# in terminal 2 do this immediately
# invoke the service 
$ curl -v http://localhost:8080
```

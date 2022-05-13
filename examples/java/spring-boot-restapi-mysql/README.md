# Description
This example shows Kontain running a Spring Boot REST API example with a backing MySQL DB.  The REST API persists entries in a MySQL DB, and the API is also be used to retrieve the entries.

Reference from:
https://www.bezkoder.com/docker-compose-spring-boot-mysql/ and https://www.bezkoder.com/spring-boot-jpa-crud-rest-api/

Please note that this shows that we can continue to use the normal Dockerfile without any conversion to using  Kontain-based language runtime.

This allows us to experience Kontain with existing Dockerfiles and images but without the benefit of smaller image sizes.

# to build this example
```bash
cd app && mvn clean compile package
cd app && docker build -t kontainguide/spring-boot-restapi-mysql:1.0 .
```

# to run this example
```bash
$ docker-compose up
...
```

The REST API should be ready at port 8080

# to test using the REST APIs
Now add 2 entries via the REST API
```bash
echo "Adding 2 tutorial entries"
echo
curl -s -XPOST -H "Content-type:application/json" http://localhost:6868/api/tutorials -d '{"title": "koder tutorial #1", "description": "Tutorial #1 description"}' | jq
{
  "id": 7,
  "title": "koder tutorial #1",
  "description": "Tutorial #1 description",
  "published": false
}

echo
curl -s -XPOST -H "Content-type:application/json" http://localhost:6868/api/tutorials -d '{"title": "koder tutorial #2", "description": "Tutorial #2 description"}' | jq
{
  "id": 8,
  "title": "koder tutorial #2",
  "description": "Tutorial #2 description",
  "published": false
}
```

Now retrieve the entries via the REST API
```bash
echo
sleep 2
echo retrieving entries
curl http://localhost:6868/api/tutorials | jq
```

# to clean
```bash
$ cd app && mvn clean
```

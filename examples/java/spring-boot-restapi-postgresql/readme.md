# Description
This shows how to run a Spring Boot Rest API Container with Postgresql as the backing DB.  The DB gets initialized automatically with products and the test queries the API for a list of products.

Note that we use runtime:krun in the docker-compose file to show that we use Kontain as the secure Docker runtime.

Also note that we continued to use a normal JIB created Dockerfile for this exercise, and shows us how to experience Kontain with existing Dockerfiles and images but without the benefit of smaller image sizes.

# to build
```shell
$ mvn clean compile package -D jib:dockerBuild -Djib.to.image=kontainguide/spring-boot-restapi-postgresql:v1 -Dmaven.test.skip
```

# run
```shell
$ docker-compose up
```

# test
to test the API:
```shell
$ curl http://localhost:8080/api/v1/products
[{"name":"Monster Tulpar T7 V20.4 Dizüstü Bilgisayar","description":"Monster Tulpar T7 V20.4 Dizüstü Bilgisayar","price":17.099,"category":"Dizüstü Bilgisayar"},{"name":"HP Pavilion Gaming 15-ec2033nt 4G8U0EA Dizüstü Bilgisayar","description":"HP Pavilion Gaming 15-ec2033nt 4G8U0EA Dizüstü Bilgisayar","price":10.199,"category":"Dizüstü Bilgisayar"},{"name":"Apple MacBook Air 13.3 İnç M1 MGN73TU/A Dizüstü Bilgisayar","description":"Apple MacBook Air 13.3 İnç M1 MGN73TU/A Dizüstü Bilgisayar","price":12.396,"category":"Dizüstü Bilgisayar"}]azure-user@smdev1:~/guide-examples/examples/java/spring-boot-postgresql$
````

# reference
An example sourced from this blog:
https://betulsahinn.medium.com/dockerizing-a-spring-boot-application-and-using-the-jib-maven-plugin-95c329866f34

with source:
https://github.com/betul-sahin/springboot-docker-maven-jib-plugin
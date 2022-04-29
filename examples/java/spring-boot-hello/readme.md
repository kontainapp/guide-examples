# ref
Example from: https://mkyong.com/spring-boot/spring-boot-hello-world-example/
tar gz from here: https://crunchify.com/maven-assembly-plugin-how-to-create-tar-gz-or-zip-archive-for-java-enterprise-project-using-maven/

# for running in java
```bash
# run with maven
$ mvn springboot:run

# in another terminal
$ curl localhost:8080
Hello from Kontain!

# to clean, test, package as jar and tar gz bundling (assembly)
$ mvn clean test package # assembly:assembly

# to run as executable jar
$ java -jar target/spring-boot-hello-1.0.jar

# in another terminal window
$ curl http://localhost:8080
Hello from Kontain!

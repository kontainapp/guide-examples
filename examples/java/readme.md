# reference for installation of Java and Maven
Install sdkman:
https://linuxhint.com/install-openjdk-fedora-linux/
USE THIS: https://sdkman.io/usage
Or: https://springframework.guru/using-sdkman-to-manage-java-versions/

```java
# install sdkman:
curl -s "https://get.sdkman.io" | bash

# list:
$ sdk list java

# install java:
$ sdk install java 11.0.2-open

# show current java:
$ sdk current java

# switch:
$ sdk use java <specific_version>
$ sdk default java <specific_version>

$ sdk uninstall java <specific_version>

$ sdk current java

$ sdk current

# installing maven
sdk install maven
```

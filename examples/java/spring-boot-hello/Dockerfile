ARG OPEN_JDK_KONTAIN_RELEASE_VERSION=kontainapp/runenv-jdk-shell-11.0.8:latest

FROM ${OPEN_JDK_KONTAIN_RELEASE_VERSION} as release

WORKDIR /opt/src/app

# copy jar
COPY target/spring-boot-hello-1.0.jar app.jar

EXPOSE 8080
CMD [ "java", "-XX:-UseCompressedOops", "-jar", "/opt/src/app/app.jar" ]

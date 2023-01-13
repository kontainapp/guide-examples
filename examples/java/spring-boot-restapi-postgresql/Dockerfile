ARG OPEN_JDK_KONTAIN_RELEASE_VERSION=kontainapp/runenv-jdk-shell-11.0.8:latest

FROM ${OPEN_JDK_KONTAIN_RELEASE_VERSION} as release

WORKDIR /app

# copy jar
COPY target/*.jar app.jar

EXPOSE 8080
CMD [ "java", "-XX:-UseCompressedOops", "-jar", "/app/app.jar" ]

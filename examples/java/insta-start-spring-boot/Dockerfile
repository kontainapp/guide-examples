ARG OPEN_JDK_BUILD_VERSION=openjdk:11-jdk-slim-buster
ARG OPEN_JDK_KONTAIN_RELEASE_VERSION=kontainapp/runenv-jdk-shell-11.0.8:latest

FROM ${OPEN_JDK_BUILD_VERSION} as build
RUN mkdir -p /tmp

# RUN mkdir -p /tmp
WORKDIR /opt/src/app

# copy jar
COPY target/spring-boot-hello-1.0.jar app.jar

FROM ${OPEN_JDK_KONTAIN_RELEASE_VERSION} as release
COPY --from=build /opt/src /opt/src
COPY --from=build /tmp /tmp

WORKDIR /opt/src/app

EXPOSE 8080
ENV KM_MGTPIPE=/tmp/km.sock

CMD [ "java", "-XX:-UseCompressedOops", "-jar", "/opt/src/app/app.jar" ]

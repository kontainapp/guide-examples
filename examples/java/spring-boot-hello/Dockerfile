ARG OPEN_JDK_BUILD_VERSION
ARG OPEN_JDK_KONTAIN_RELEASE_VERSION

FROM ${OPEN_JDK_BUILD_VERSION} as build
# RUN mkdir -p /tmp
WORKDIR /opt/src/app

# copy jar
COPY target/spring-boot-hello-1.0.jar app.jar

FROM ${OPEN_JDK_KONTAIN_RELEASE_VERSION} as release
COPY --from=build /opt/src /opt/src

WORKDIR /opt/src/app

EXPOSE 8080
CMD [ "java", "-XX:-UseCompressedOops", "-jar", "/opt/src/app/app.jar" ]

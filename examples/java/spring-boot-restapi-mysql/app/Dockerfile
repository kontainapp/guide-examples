FROM openjdk:11-jdk-slim-buster as build
# RUN mkdir -p /tmp
WORKDIR /opt/src/app

# copy jar
COPY target/*.jar app.jar

CMD [ "java", "-XX:-UseCompressedOops", "-jar", "/opt/src/app/app.jar" ]

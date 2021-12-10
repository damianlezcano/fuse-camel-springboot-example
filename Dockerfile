FROM alpine/git
WORKDIR /app
RUN git clone -b cicd https://damianlezcano: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@github.com/operations-innovation/entity-traceability-producer.git .


FROM maven:3.6.1-jdk-8-slim AS build
COPY src /app/src
COPY pom.xml /app/
COPY settings.xml /app/
RUN mvn -f /app/pom.xml -s /app/settings.xml clean package

FROM registry.redhat.io/fuse7/fuse-java-openshift:1.2
USER root

EXPOSE 8080
EXPOSE 9779
EXPOSE 8778

ENV DEPLOYMENT_HOME /deployments
ENV APP_FILE entity-traceability-producer.jar
COPY target/$APP_FILE $DEPLOYMENT_HOME/

WORKDIR $DEPLOYMENT_HOME

ENTRYPOINT ["java", "-jar", "$APP_FILE"]

# FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

# MAINTAINER Muhammad Edwin < edwin at redhat dot com >

# LABEL BASE_IMAGE="registry.access.redhat.com/ubi8/ubi-minimal:8.5"
# LABEL JAVA_VERSION="11"

# RUN microdnf install --nodocs java-11-openjdk-headless && microdnf clean all

# WORKDIR /work/
# COPY target/*.jar /work/application.jar

# EXPOSE 8080
# CMD ["java", "-jar", "application.jar"]

FROM maven:3.8.8-eclipse-temurin-21 AS build
WORKDIR /app


WORKDIR /app
COPY pom.xml ./
COPY src ./src

# Build the application, skipping tests to save time
RUN mvn clean install -DskipTests


# Use a lightweight JDK 11 image to run the application
FROM eclipse-temurin:21-jdk AS runtime
WORKDIR /app

# Copy the JAR built in the previous step
COPY --from=build /app/target/*.jar application.jar

# Expose the port used by the application
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "application.jar"]

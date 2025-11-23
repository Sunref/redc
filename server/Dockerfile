# --- Build stage -----------------------------------------------------------
FROM eclipse-temurin:25-jdk AS build
WORKDIR /workspace
# Pre-fetch Maven wrapper + dependencies for reproducible builds
COPY spring-petclinic/mvnw spring-petclinic/mvnw.cmd spring-petclinic/pom.xml ./
COPY spring-petclinic/.mvn .mvn
RUN chmod +x mvnw

# Copy the rest of the project sources
COPY spring-petclinic/src src

# Build the Spring Boot application
RUN ./mvnw package -DskipTests
# --- Runtime stage ---------------------------------------------------------

FROM eclipse-temurin:25-jre


WORKDIR /app
# Copy the packaged application
COPY --from=build /workspace/target/*.jar app.jar
EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=postgres \
    JAVA_OPTS=""
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Dserver.servlet.context-path=/petclinic -jar /app/app.jar"]

# Build stage
FROM eclipse-temurin:21-jdk AS build
WORKDIR /workspace/app

# Copy gradle files
COPY build.gradle.kts settings.gradle.kts gradlew ./
COPY gradle ./gradle

# Download dependencies
RUN ./gradlew dependencies --no-daemon

# Copy source code
COPY src ./src

# Build the application
RUN ./gradlew bootJar --no-daemon

# Runtime stage
FROM eclipse-temurin:21-jdk
VOLUME /tmp
WORKDIR /app

# Copy the jar from build stage
COPY --from=build /workspace/app/build/libs/*.jar app.jar

# Set entrypoint
ENTRYPOINT ["java", "-jar", "app.jar"]
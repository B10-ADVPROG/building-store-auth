# Build stage
FROM eclipse-temurin:21.0.2_13-jdk AS build
WORKDIR /workspace/app

# Copy gradle files
COPY build.gradle.kts settings.gradle.kts gradlew ./
COPY gradle ./gradle

# Make gradlew executable
RUN chmod +x ./gradlew

# Download dependencies
RUN ./gradlew dependencies --no-daemon

# Copy source code
COPY src ./src

# Build the application
RUN ./gradlew bootJar --no-daemon

# Runtime stage
FROM eclipse-temurin:21.0.2_13-jre
WORKDIR /app

# Copy the jar from build stage
COPY --from=build /workspace/app/build/libs/*.jar app.jar

# Expose PORT for Railway
EXPOSE ${PORT:-8080}

# Set entrypoint with Railway-friendly configuration
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]
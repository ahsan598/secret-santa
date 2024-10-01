# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Expose the application port
EXPOSE 8070

# Environment variable to specify the app home directory
ENV APP_HOME /usr/src/app

# Copy the JAR file into the container
COPY target/secretsanta-0.0.3-SNAPSHOT.jar $APP_HOME/app.jar

# Set the entry point to run the Java application
ENTRYPOINT ["java", "-jar", "app.jar"]

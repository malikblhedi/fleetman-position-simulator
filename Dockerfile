FROM openjdk:8u411-jre
WORKDIR /app
ADD target/positionsimulator-0.0.1-SNAPSHOT.jar webapp.jar
EXPOSE 8080
CMD ["java", "-jar", "webapp.jar"]

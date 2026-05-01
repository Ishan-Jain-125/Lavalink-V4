FROM eclipse-temurin:17-jre-alpine
WORKDIR /opt/lavalink
COPY Lavalink.jar Lavalink.jar
COPY application.yml application.yml
EXPOSE 8080
CMD ["java", "-jar", "Lavalink.jar"]

FROM eclipse-temurin:17-jre-alpine

WORKDIR /opt/lavalink

# Automatically download the latest Lavalink v4.2.2 release
RUN wget https://github.com/lavalink-devs/Lavalink/releases/download/4.2.2/Lavalink.jar

# Copy your local configuration file
COPY application.yml application.yml

EXPOSE 8080

CMD ["java", "-jar", "Lavalink.jar"]

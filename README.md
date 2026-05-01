
# Lavalink V4 - Discord Music Server

A high-performance audio node server for Discord bots using Lavalink V4 and Wavelink v3. This repository contains everything you need to set up and deploy a Lavalink server for playing music in your Discord bot.

## 📋 Table of Contents

- [About](#about)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Docker Deployment](#docker-deployment)
- [Running Lavalink](#running-lavalink)
- [Wavelink v3 Integration](#wavelink-v3-integration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 📖 About

Lavalink V4 is a standalone audio server that handles all audio playback for your Discord bot. This implementation is designed to work seamlessly with **Wavelink v3**, a popular Python library for interacting with Lavalink.

Instead of processing audio within your bot, Lavalink separates audio handling into its own process, which:
- Reduces bot memory usage
- Improves stability and reliability
- Allows multiple bots to connect to a single node
- Provides scalability for large deployments

## ✨ Features

- **High Performance Audio Playback** - Supports YouTube, Spotify, SoundCloud, and more
- **Low Latency** - Optimized for real-time audio streaming
- **Clustering Support** - Connect multiple Lavalink nodes for redundancy
- **Docker Ready** - Easy containerization and deployment
- **REST API** - Full control over playback via HTTP endpoints
- **WebSocket Support** - Real-time event streaming to bots
- **Configurable Filters** - Apply audio filters (bass boost, volume, etc.)
- **Queue Management** - Built-in queue handling and track management

## 📦 Requirements

### Local Installation
- **Java 17 or higher** (OpenJDK or Eclipse Temurin recommended)
- **Maven** (for building from source)
- **2GB RAM** minimum (4GB+ recommended for production)
- **Linux/macOS/Windows** supported

### Docker Installation
- **Docker** (20.10 or higher)
- **Docker Compose** (optional, for easier management)

## 🚀 Installation

### Option 1: Local Installation

#### 1. Download Lavalink

```bash
# Create a directory for Lavalink
mkdir lavalink && cd lavalink

# Download the latest Lavalink V4 JAR
wget https://github.com/lavalink-devs/Lavalink/releases/download/v4.0.0/Lavalink.jar

# Or using curl
curl -L -o Lavalink.jar https://github.com/lavalink-devs/Lavalink/releases/download/v4.0.0/Lavalink.jar
```

#### 2. Create Configuration File

Create an `application.yml` file in the same directory:

```yaml
server:
  port: 8080
  address: localhost

lavalink:
  server:
    password: "yoursecurepassword"
    sources:
      youtube: true
      bandcamp: true
      soundcloud: true
      twitch: true
      vimeo: true
      mixer: true
      http: true
      local: false
    filters:
      volume: true
      equalizer: true
      karaoke: true
      timescale: true
      tremolo: true
      vibrato: true
      rotation: true
      distortion: true
      channelmix: true
      lowpass: true
    bufferDurationMs: 400
    youtubePlaylistLoadLimit: 6
    playerUpdateInterval: 5
    youtubeSearchEnabled: true
    soundcloudSearchEnabled: true
    gc-warnings: true

metrics:
  prometheus:
    enabled: false
    endpoint: /metrics

sentry:
  dsn: ""
  environment: ""
  traces-sample-rate: 1.0

logging:
  level:
    root: INFO
    lavalink: INFO
  file:
    max-history: 30
    max-size: 1GB
  path: ./logs/
```

#### 3. Run Lavalink

```bash
java -jar Lavalink.jar
```

Lavalink should now be running on `http://localhost:8080`

### Option 2: Docker Installation

#### 1. Build the Docker Image

```bash
docker build -t lavalink-v4 .
```

#### 2. Run the Container

```bash
docker run -d \
  --name lavalink \
  -p 8080:8080 \
  -v $(pwd)/application.yml:/opt/lavalink/application.yml \
  -e LAVALINK_SERVER_PASSWORD="yoursecurepassword" \
  lavalink-v4
```

#### 3. Using Docker Compose

Create a `docker-compose.yml`:

```yaml
version: '3.8'

services:
  lavalink:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: lavalink-v4
    ports:
      - "8080:8080"
    volumes:
      - ./application.yml:/opt/lavalink/application.yml
      - ./logs:/opt/lavalink/logs
    environment:
      - LAVALINK_SERVER_PASSWORD=yoursecurepassword
    restart: unless-stopped
    networks:
      - lavalink-network

networks:
  lavalink-network:
    driver: bridge
```

Then run:

```bash
docker-compose up -d
```

## ⚙️ Configuration

### Key Configuration Options

| Setting | Description | Default |
|---------|-------------|---------|
| `server.port` | Port Lavalink listens on | `8080` |
| `server.address` | Bind address | `localhost` |
| `lavalink.server.password` | Password for bot connections | (required) |
| `bufferDurationMs` | Audio buffer duration | `400` |
| `playerUpdateInterval` | Update interval in seconds | `5` |
| `youtubePlaylistLoadLimit` | Max tracks from YouTube playlists | `6` |

### Audio Sources

Enable/disable audio sources in `application.yml`:

```yaml
lavalink:
  server:
    sources:
      youtube: true        # YouTube playback
      bandcamp: true       # Bandcamp support
      soundcloud: true     # SoundCloud support
      twitch: true         # Twitch streams
      vimeo: true          # Vimeo videos
      mixer: true          # Mixer streams
      http: true           # Direct HTTP streams
      local: false         # Local file playback
```

### Audio Filters

Configure available audio filters:

```yaml
lavalink:
  server:
    filters:
      volume: true         # Volume adjustment
      equalizer: true      # 15-band equalizer
      karaoke: true        # Karaoke effect
      timescale: true      # Speed/pitch adjustment
      tremolo: true        # Volume modulation
      vibrato: true        # Pitch modulation
      rotation: true       # Stereo rotation
      distortion: true     # Distortion effect
      channelmix: true     # Channel mixing
      lowpass: true        # Low-pass filter
```

## 🐳 Docker Deployment

### Fixed Dockerfile Issue

**Note:** The provided Dockerfile has a port conflict. It exposes port 443 instead of 8080. The corrected version:

```dockerfile
FROM eclipse-temurin:17-jre-alpine
WORKDIR /opt/lavalink
COPY Lavalink.jar Lavalink.jar
COPY application.yml application.yml
EXPOSE 8080
CMD ["java", "-jar", "Lavalink.jar"]
```

### Production Deployment Tips

1. **Use Alpine Linux** - Reduces image size and memory footprint
2. **Expose correct port** - Use 8080 or your configured port
3. **Volume mounting** - Keep logs and config outside container
4. **Resource limits** - Set appropriate CPU and memory constraints
5. **Restart policy** - Use `unless-stopped` for production
6. **Health checks** - Add health check endpoints to Docker Compose

### Docker Health Check Example

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080/info"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

## 🤖 Wavelink v3 Integration

### Python Bot Setup

#### 1. Install Wavelink

```bash
pip install wavelink
```

#### 2. Connect to Lavalink

```python
import discord
from discord.ext import commands, tasks
import wavelink

class Bot(commands.Cog):
    def __init__(self, bot):
        self.bot = bot
        
    async def connect_nodes(self):
        """Connect to Lavalink nodes"""
        await self.bot.wait_until_ready()
        
        node: wavelink.Node = wavelink.Node(
            uri="http://localhost:8080",
            password="yoursecurepassword"
        )
        
        await wavelink.NodePool.connect(client=self.bot, nodes=[node])

bot = commands.Bot(command_prefix="!")

@bot.event
async def on_ready():
    print(f"Bot logged in as {bot.user}")

async def main():
    async with bot:
        cog = Bot(bot)
        await cog.connect_nodes()
        await bot.start("YOUR_DISCORD_TOKEN")

# Run the bot
if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

#### 3. Create a Music Cog

```python
import discord
from discord.ext import commands
import wavelink

class Music(commands.Cog):
    def __init__(self, bot):
        self.bot = bot
    
    @commands.command()
    async def play(self, ctx, *, query: str):
        """Play a song"""
        if not ctx.author.voice:
            await ctx.send("You must be in a voice channel")
            return
        
        player: wavelink.Player = await ctx.author.voice.channel.connect(
            cls=wavelink.Player,
            self_deaf=True
        )
        
        tracks = await wavelink.NodePool.get_node().get_tracks(
            wavelink.TrackSource.YOUTUBE_MUSIC,
            query
        )
        
        if not tracks:
            await ctx.send("No tracks found")
            return
        
        track = tracks[0]
        await player.play(track)
        await ctx.send(f"Now playing: **{track.title}**")
    
    @commands.command()
    async def stop(self, ctx):
        """Stop playback"""
        player: wavelink.Player = ctx.voice_client
        if player:
            await player.stop()
            await ctx.send("Playback stopped")
    
    @commands.command()
    async def pause(self, ctx):
        """Pause playback"""
        player: wavelink.Player = ctx.voice_client
        if player:
            await player.pause(not player.is_paused())
            status = "paused" if player.is_paused() else "resumed"
            await ctx.send(f"Playback {status}")

async def setup(bot):
    await bot.add_cog(Music(bot))
```

## 🔧 Troubleshooting

### Connection Issues

**Problem:** Bot can't connect to Lavalink

```
Solution:
1. Check Lavalink is running: curl http://localhost:8080/info
2. Verify password matches in bot and Lavalink config
3. Check firewall allows port 8080
4. Ensure correct IP/hostname in bot connection
```

### No Audio Output

```
Solution:
1. Verify bot is in voice channel
2. Check Lavalink logs for errors
3. Ensure YouTube/SoundCloud sources are enabled
4. Verify bot has permission to speak in channel
```

### High Latency

```
Solution:
1. Increase bufferDurationMs in application.yml
2. Use server closer to your bot
3. Check network connectivity
4. Monitor system resources (CPU/RAM)
```

### Docker Port Conflicts

```
Solution:
1. Change port mapping: -p 8081:8080
2. Check existing containers: docker ps
3. Stop conflicting containers: docker stop <container_id>
```

## 📊 Monitoring

### REST API Endpoints

```bash
# Get node information
curl http://localhost:8080/info

# Get player status
curl http://localhost:8080/v4/sessions/{sessionId}/players/{guildId}

# Get Lavalink stats
curl http://localhost:8080/v4/info
```

### Checking Logs

```bash
# Local deployment
tail -f logs/application.log

# Docker deployment
docker logs -f lavalink
```

## 🆘 Getting Help

- **Lavalink Documentation:** https://lavalink.dev/
- **Wavelink Documentation:** https://wavylink.dev/
- **GitHub Issues:** Report bugs on this repository
- **Discord Support:** Join Lavalink dev community

## 📝 License

This project is licensed under the MIT License - see LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Last Updated:** 2026-05-01
**Lavalink Version:** V4
**Wavelink Version:** v3


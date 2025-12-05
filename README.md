# Plex Media Server

Docker-based Plex Media Server setup with easy management script.

## Quick Start

After cloning this repository, run the setup script to install the `plex` command:

```bash
./setup.sh
```

This will install the `plex` script to `/usr/local/bin`, making it available system-wide.

**Supported systems:** macOS, Debian, Ubuntu

To uninstall later:
```bash
./setup.sh uninstall
```

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop) (macOS/Windows) or Docker Engine (Linux) installed and running

## Initial Setup

### 1. Configure Environment Variables

Copy the example environment file and customize it:

```bash
cp .env.example .env
```

Edit `.env` and set the following:

#### Required:
- **PLEX_CLAIM**: Get your token from [https://www.plex.tv/claim/](https://www.plex.tv/claim/)
  - **Important:** The token expires in 4 minutes

#### Platform-specific:
- **PUID/PGID**: Your user and group IDs
  - **Linux (Ubuntu/Debian)**: Usually `1000/1000` (default)
  - **macOS**: Usually `501/20`
  - Find yours with: `id -u` and `id -g`

#### Media directories:
- **MOVIES_DIR**: Full path to your movies folder
- **TV_DIR**: Full path to your TV shows folder

Example `.env` file:
```bash
PLEX_CLAIM="claim-xxxxxxxxxxxx"
PUID=1000
PGID=1000
MOVIES_DIR=/home/username/media/movies
TV_DIR=/home/username/media/tv
```

### 2. Start the Server

If you installed the `plex` command globally (via `./setup.sh`), run:

```bash
plex start
```

Otherwise, run from this directory:

```bash
./plex start
```

## Usage

Once installed globally, you can use the `plex` command from anywhere. If not installed globally, use `./plex` from this directory.

### Start Plex Server

```bash
plex start
```

### Stop Plex Server

```bash
plex stop
```

### Restart Plex Server

```bash
plex restart
```

### View Logs

```bash
plex logs
```

Press `Ctrl+C` to exit log view.

### Check Status

```bash
plex status
```

## Accessing Plex

Once the server is running, access the web interface at:

**http://localhost:32400/web**

## Configuration

### Ports

The following ports are exposed:

- `32400` - Web UI and API
- `32469` - GDM network discovery
- `8324` - Remote control (Roku/Chromecast)
- `1900` - DLNA discovery (UDP)
- `32410-32414` - GDM network discovery (UDP)

### Resource Limits

Memory is limited to 4GB. Adjust in `docker-compose.yml` if needed:

```yaml
deploy:
  resources:
    limits:
      memory: 4G
```

### Data Persistence

Configuration and metadata are stored in a Docker volume named `plex_config`. This persists across container restarts.

## Troubleshooting

### Server Won't Start

Check if Docker Desktop is running:

```bash
docker ps
```

### Can't Access Web Interface

1. Verify the container is running: `./plex status`
2. Check logs: `./plex logs`
3. Ensure port 32400 isn't blocked by firewall

### Claim Token Expired

If you see authentication errors:

1. Get a new token from [https://www.plex.tv/claim/](https://www.plex.tv/claim/)
2. Update `.env` file with new token
3. Restart: `./plex restart`

### Media Not Showing Up

1. Verify media directories exist and contain files
2. Check file permissions (files should be readable by UID 501)
3. In Plex web UI, go to Settings > Manage > Libraries and scan

## Updating Plex

Pull the latest image and restart:

```bash
docker compose pull
./plex restart
```

## Uninstalling

Stop and remove containers, networks, and volumes:

```bash
./plex stop
docker compose down -v  # Warning: -v removes all data including config
```

To keep your configuration and just remove the container:

```bash
./plex stop
docker compose down  # Keeps volumes intact
```

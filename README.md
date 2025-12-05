# Plex Media Server

Docker-based Plex Media Server setup with easy management script.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running
- macOS user account (configured for user ID 501)

## Initial Setup

### 1. Get Your Plex Claim Token

Visit [https://www.plex.tv/claim/](https://www.plex.tv/claim/) to get your claim token.

**Important:** The token expires in 4 minutes, so have it ready before starting the server.

### 2. Set Your Claim Token

Create a `.env` file in this directory:

```bash
echo "PLEX_CLAIM=claim-xxxxxxxxxxxx" > .env
```

Replace `claim-xxxxxxxxxxxx` with your actual token from step 1.

### 3. Customize Media Directories (Optional)

Edit `docker-compose.yml` to change the media locations:

```yaml
volumes:
  - plex_config:/config
  - /path/to/your/movies:/movies
  - /path/to/your/tv:/tv
```

Current configuration:
- Movies: `/Users/monty/Downloads/Movies`
- TV Shows: `/Users/monty/Downloads/TV`

### 4. Make the Management Script Executable

```bash
chmod +x plex
```

### 5. Add Script to PATH (Optional)

To run `plex` from anywhere, add a symlink:

```bash
sudo ln -s ~/dv/plex-server/plex /usr/local/bin/plex
```

Or add this directory to your PATH in `~/.zshrc` or `~/.bash_profile`:

```bash
export PATH="$HOME/dv/plex-server:$PATH"
```

## Usage

### Start Plex Server

```bash
./plex start
```

### Stop Plex Server

```bash
./plex stop
```

### Restart Plex Server

```bash
./plex restart
```

### View Logs

```bash
./plex logs
```

Press `Ctrl+C` to exit log view.

### Check Status

```bash
./plex status
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

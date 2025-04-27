# Docker Development Environments

This repository contains Dockerfiles for creating consistent development environments for Node.js and Python projects. These development containers provide isolated environments with SSH access, making them ideal for remote development.

## Features

- **SSH Access**: Both environments include OpenSSH server for remote development
- **Environment Configuration**: Configure Git user and SSH settings via environment variables
- **Multiple Development Environments**:
  - Node.js development environment
  - Python development environment

## Container Images

### Base Development Environment

The base development environment:

- Ubuntu 24.04 base
- OpenSSH server for remote access
- Common development tools (git, curl, wget, etc.)

### Node.js Development Environment

The Node.js development environment (`dockerfile-node`) includes:

- Node.js 20.x with npm
- Yarn package manager

### Python Development Environment

The Python development environment (`dockerfile-python`) includes:

- Python 3 with pip and venv
- Python virtual environment at `/opt/venv`

## Startup Configuration

Both environments use the `configure-startup.sh` script to:

1. Configure SSH access using provided SSH keys
2. Set up Git user configuration
3. Start the SSH server on the specified port

### Environment Variables

The containers support the following environment variables:

- `AUTHORIZED_KEYS`: SSH public key(s) for passwordless authentication - Mandatory
- `GIT_USER`: Git username to configure globally
- `GIT_EMAIL`: Git email to configure globally
- `SSH_PORT`: Port for the SSH server (defaults to 22)

## Usage

### Docker Run Command

```bash
# Run Node.js development environment
docker run -d \
  -p 2222:22 \
  -e AUTHORIZED_KEYS="$(cat ~/.ssh/id_rsa.pub)" \
  -e GIT_USER="Username" \
  -e GIT_EMAIL="your.email@example.com" \
  -v /opt/node-app:/app \
  miguel1993/docker-dev:node

# Run Python development environment
docker run -d \
  -p 2223:22 \
  -e AUTHORIZED_KEYS="$(cat ~/.ssh/id_rsa.pub)" \
  -e GIT_USER="Username" \
  -e GIT_EMAIL="your.email@example.com" \
  -v /opt/python-app:/app \
  miguel1993/docker-dev:python
```

### Using Docker Compose

You can also use Docker Compose to run both environments together:

```yaml
version: '3'

services:
  node-dev:
    container_name: node-dev
    image: miguel1993/docker-dev:node
    network_mode: host
    ports:
      - "2222:22"
    environment:
      - AUTHORIZED_KEYS=ssh-rsa YOUR_PUBLIC_KEY
      - GIT_USER=Your Name
      - GIT_EMAIL=your.email@example.com
      - SSH_PORT=22
    volumes:
      - /opt/node-app:/app

  python-dev:
    container_name: python-dev
    image: miguel1993/docker-dev:python
    network_mode: host
    ports:
      - "2223:22"
    environment:
      - AUTHORIZED_KEYS=ssh-rsa YOUR_PUBLIC_KEY
      - GIT_USER=Your Name
      - GIT_EMAIL=your.email@example.com
      - SSH_PORT=22
    volumes:
      - /opt/python-app:/app
```

Save this as `docker-compose.yml` and run with:

```bash
docker-compose up -d
```

## About This Project

This project was primarily AI-generated using Windsurf and Claude 3.7. The Docker configurations, scripts, and documentation were created through AI assistance with human guidance and refinement.

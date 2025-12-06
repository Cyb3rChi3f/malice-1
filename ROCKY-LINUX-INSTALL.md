# Rocky Linux 8.10 Installation Guide for Malice

This guide provides instructions for installing and running Malice on Rocky Linux 8.10 (and compatible RHEL-based distributions like AlmaLinux, CentOS Stream 8+).

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [System Requirements](#system-requirements)
3. [Installation Methods](#installation-methods)
   - [Method 1: Using Vagrant (Recommended for Development)](#method-1-using-vagrant-recommended-for-development)
   - [Method 2: Manual Installation on Rocky Linux](#method-2-manual-installation-on-rocky-linux)
4. [SELinux Considerations](#selinux-considerations)
5. [Running Malice](#running-malice)
6. [Starting the Elasticsearch Stack](#starting-the-elasticsearch-stack)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

- Rocky Linux 8.10 (or compatible RHEL-based distribution)
- Root or sudo access
- At least 4GB RAM (8GB recommended for Elasticsearch)
- At least 25GB disk space
- Internet connection for downloading packages

---

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| RAM | 4GB | 8GB+ |
| CPU | 2 cores | 4+ cores |
| Disk Space | 25GB | 50GB+ |
| OS | Rocky Linux 8.10 | Rocky Linux 8.10 |

---

## Installation Methods

### Method 1: Using Vagrant (Recommended for Development)

This method creates a complete development environment in a VM.

#### Step 1: Install Prerequisites

```bash
# Install VirtualBox
sudo dnf install -y epel-release
sudo dnf config-manager --add-repo=https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo
sudo dnf install -y VirtualBox-7.0

# Install Vagrant
sudo dnf install -y wget
wget https://releases.hashicorp.com/vagrant/2.4.0/vagrant_2.4.0-1.x86_64.rpm
sudo dnf install -y ./vagrant_2.4.0-1.x86_64.rpm

# Install vagrant-disksize plugin
vagrant plugin install vagrant-disksize
```

#### Step 2: Use the Rocky Linux Vagrantfile

```bash
# Clone the malice repository
git clone https://github.com/maliceio/malice.git
cd malice

# Use the Rocky Linux Vagrantfile
cp Vagrantfile.rockylinux Vagrantfile

# Start the VM
vagrant up

# SSH into the VM
vagrant ssh
```

#### Step 3: Verify Installation

```bash
# Check Docker
docker --version
docker ps

# Check Go
go version

# Check Malice
malice --help
```

---

### Method 2: Manual Installation on Rocky Linux

This method installs Malice directly on your Rocky Linux system.

#### Step 1: Update System

```bash
sudo dnf update -y
sudo dnf install -y ca-certificates curl wget tar git
```

#### Step 2: Install Docker

```bash
# Remove old Docker versions if present
sudo dnf remove -y docker docker-client docker-client-latest \
                   docker-common docker-latest docker-latest-logrotate \
                   docker-logrotate docker-engine

# Add Docker CE repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker CE
sudo dnf install -y docker-ce docker-ce-cli containerd.io \
                    docker-buildx-plugin docker-compose-plugin

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to docker group (replace $USER with your username)
sudo usermod -aG docker $USER

# Log out and back in for group membership to take effect
# Or run: newgrp docker
```

#### Step 3: Configure SELinux for Docker

```bash
# Enable container management
sudo setsebool -P container_manage_cgroup on

# Set correct context on docker socket
sudo chcon -t container_file_t /var/run/docker.sock

# If you encounter persistent SELinux issues, you can check denials:
sudo ausearch -m avc -ts recent

# Optional: Set SELinux to permissive mode (not recommended for production)
# sudo setenforce 0
# sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
```

#### Step 4: Install Docker Compose (Standalone)

```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version
```

#### Step 5: Install Go

```bash
# Download and install Go 1.21.5
export GO_VERSION=1.21.5
wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz

# Extract to /usr/local
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz

# Add Go to PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verify installation
go version
```

#### Step 6: Install Build Dependencies

```bash
# Install development tools
sudo dnf groupinstall -y "Development Tools"

# Install file-devel (libmagic) for malware analysis
sudo dnf install -y file-devel gcc make cmake gcc-c++
```

#### Step 7: Build and Install Malice

```bash
# Create Go workspace
mkdir -p $GOPATH/src/github.com/maliceio
cd $GOPATH/src/github.com/maliceio

# Clone malice repository
git clone https://github.com/maliceio/malice.git
cd malice

# Download dependencies
go mod download

# Build malice
go build -o $GOPATH/bin/malice

# Install malice system-wide (optional)
sudo cp $GOPATH/bin/malice /usr/local/bin/malice
sudo chmod +x /usr/local/bin/malice

# Verify installation
malice --help
```

#### Step 8: Configure Elasticsearch Requirements

```bash
# Elasticsearch requires vm.max_map_count to be at least 262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -w vm.max_map_count=262144

# Verify setting
sysctl vm.max_map_count
```

#### Step 9: Install Go Development Tools (Optional)

```bash
# Install Delve debugger
go install github.com/go-delve/delve/cmd/dlv@latest
```

---

## SELinux Considerations

Rocky Linux 8.10 has SELinux enabled by default in **enforcing** mode. This provides enhanced security but may require additional configuration.

### Common SELinux Issues and Solutions

#### Issue 1: Docker Socket Permission Denied

**Symptom:** `permission denied while trying to connect to the Docker daemon socket`

**Solution:**
```bash
# Set correct SELinux context
sudo chcon -t container_file_t /var/run/docker.sock

# Make persistent across reboots
sudo semanage fcontext -a -t container_file_t "/var/run/docker.sock"
sudo restorecon -v /var/run/docker.sock
```

#### Issue 2: Container Volume Mounting Issues

**Symptom:** Containers cannot access mounted volumes

**Solution:**
```bash
# Add :z or :Z flag to volume mounts in docker-compose.yml
# :z = shared between containers
# :Z = private to container
volumes:
  - ./data:/malware:z
```

#### Issue 3: Checking SELinux Denials

```bash
# Check recent SELinux denials
sudo ausearch -m avc -ts recent

# Check SELinux status
getenforce

# Generate SELinux policy from denials (advanced)
sudo ausearch -m avc | audit2allow -M malice_policy
sudo semodule -i malice_policy.pp
```

### Disabling SELinux (Not Recommended for Production)

If you encounter persistent issues and need to disable SELinux temporarily:

```bash
# Set to permissive mode (logs denials but doesn't block)
sudo setenforce 0

# Make permanent (requires reboot)
sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# Verify
getenforce
```

---

## Running Malice

### Basic Usage

```bash
# Scan a file
malice scan /path/to/suspicious/file

# Scan with specific plugins
malice scan --plugin=clamav /path/to/file

# Get help
malice --help
```

### Configuration

Malice stores configuration in `~/.malice/`:

```bash
# View configuration
cat ~/.malice/config.toml

# Edit configuration
vi ~/.malice/config.toml
```

---

## Starting the Elasticsearch Stack

The Elasticsearch, Logstash, and Kibana stack is configured via docker-compose.

### Step 1: Navigate to Project Directory

```bash
cd /path/to/malice
```

### Step 2: Start Services

```bash
# Start all services in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

### Step 3: Verify Services

```bash
# Check Elasticsearch (should return cluster info)
curl http://localhost:9200

# Access Kibana in browser
# Open: http://localhost:8080 (or configured port)

# Check Logstash
curl http://localhost:9600
```

### Step 4: Stop Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes data)
docker-compose down -v
```

---

## Troubleshooting

### Docker Issues

#### Problem: Cannot connect to Docker daemon

```bash
# Check if Docker is running
sudo systemctl status docker

# Start Docker if not running
sudo systemctl start docker

# Check user is in docker group
groups

# If not in docker group, add and log out/in
sudo usermod -aG docker $USER
```

#### Problem: Docker socket permission denied

```bash
# Fix SELinux context
sudo chcon -t container_file_t /var/run/docker.sock

# Or temporarily disable SELinux
sudo setenforce 0
```

### Elasticsearch Issues

#### Problem: Elasticsearch container exits immediately

```bash
# Check vm.max_map_count
sysctl vm.max_map_count

# Should be at least 262144
sudo sysctl -w vm.max_map_count=262144
```

#### Problem: Out of memory errors

```bash
# Increase VM memory in docker-compose.yml
# Edit ES_JAVA_OPTS environment variable:
- "ES_JAVA_OPTS=-Xms1g -Xmx1g"  # Increase from 512m
```

### Build Issues

#### Problem: Missing file-devel package

```bash
# Install file-devel
sudo dnf install -y file-devel
```

#### Problem: Go build fails with CGO errors

```bash
# Ensure gcc is installed
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y gcc gcc-c++
```

### Network Issues

#### Problem: Cannot access services on localhost

```bash
# Check firewall rules
sudo firewall-cmd --list-all

# Add ports if needed
sudo firewall-cmd --permanent --add-port=9200/tcp  # Elasticsearch
sudo firewall-cmd --permanent --add-port=8080/tcp  # Kibana
sudo firewall-cmd --reload
```

### SELinux Issues

#### Problem: Persistent permission denials

```bash
# Check SELinux denials
sudo ausearch -m avc -ts recent | less

# Temporarily set to permissive for testing
sudo setenforce 0

# Run your command
# Check if it works

# Re-enable SELinux
sudo setenforce 1

# If it worked in permissive mode, you need to create policy
# See SELinux section above
```

---

## Package Name Differences: Rocky vs Ubuntu

For reference, here are the package name differences:

| Purpose | Ubuntu | Rocky Linux 8.10 |
|---------|--------|------------------|
| File library | libmagic-dev | file-devel |
| Build tools | build-essential | gcc, make, cmake, gcc-c++ |
| Development tools | - | "Development Tools" group |
| Package manager | apt-get | dnf |
| Architecture | dpkg --print-architecture | uname -m |

---

## Additional Resources

- [Rocky Linux Documentation](https://docs.rockylinux.org/)
- [Docker on Rocky Linux](https://docs.docker.com/engine/install/centos/)
- [SELinux User Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/)
- [Malice GitHub Repository](https://github.com/maliceio/malice)
- [Elasticsearch on Docker](https://www.elastic.co/guide/en/elasticsearch/reference/8.11/docker.html)

---

## Support

For issues specific to Rocky Linux installation:
1. Check this troubleshooting section
2. Review SELinux audit logs: `sudo ausearch -m avc -ts recent`
3. Check system logs: `sudo journalctl -xe`
4. Open an issue on GitHub with detailed error messages

---

## Version Compatibility

This guide was tested with:
- Rocky Linux 8.10
- Docker CE 24.0+
- Go 1.21.5
- Elasticsearch/Logstash/Kibana 8.11.3

It should also work with:
- AlmaLinux 8+
- CentOS Stream 8+
- RHEL 8+

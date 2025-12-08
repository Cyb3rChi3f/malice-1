# Ubuntu 24.04 LTS Updates

This document outlines the changes made to ensure compatibility with Ubuntu 24.04 LTS (Noble Numbat).

## Summary of Changes

### 1. Vagrantfile Updates

#### Base Image
- **Changed**: Ubuntu base box from `ubuntu/xenial64` (16.04) to `ubuntu/noble64` (24.04)
- **Reason**: Ubuntu 16.04 reached end-of-life in April 2021

#### Docker Installation
- **Changed**: Replaced deprecated Docker installation method with official Docker installation for Ubuntu 24.04
- **Old method**: Used deprecated `apt.dockerproject.org` repository
- **New method**: Uses Docker's official GPG key and repository with proper keyring management
- **Removed packages**:
  - `apt-transport-https` (built into apt since Ubuntu 18.04)
  - `linux-image-extra-$(uname -r)` (package no longer exists)
  - `docker-engine` (replaced by `docker-ce`)
- **Added packages**:
  - `docker-ce`, `docker-ce-cli`, `containerd.io`
  - `docker-buildx-plugin`, `docker-compose-plugin`

#### Docker Compose
- **Changed**: Updated to use latest docker-compose version
- **Old version**: 1.8.0 (from 2016)
- **New version**: Latest stable release

#### Go Version
- **Changed**: Updated from Go 1.11.2 to Go 1.21.5
- **Reason**: Go 1.11 is very outdated; Go 1.21 includes security fixes and performance improvements
- **Changed**: Updated download URL from `storage.googleapis.com/golang` to `go.dev/dl`

#### Dependency Management
- **Changed**: Removed deprecated `dep` tool commands
- **Replaced with**: Go modules (`go mod download`)
- **Added**: Proper directory creation for Go workspace

#### System Configuration
- **Added**: Immediate application of `vm.max_map_count` setting with `sysctl -w`
- **Updated**: Go tooling installation to use `go install` with `@latest` for Delve debugger

### 2. Dockerfile Updates

#### Base Image
- **Changed**: Alpine Linux from 3.8 to 3.19
- **Reason**: Alpine 3.8 is from 2018 and lacks security updates

#### Packages
- **Removed**: `mercurial` (no longer needed)
- **Removed**: `dep` (replaced by Go modules)

#### Build Process
- **Changed**: `dep ensure` to `go mod download`
- **Fixed**: Build ldflags to match actual variable names in main.go (`version` and `date` instead of `Version` and `BuildTime`)

### 3. Go Code Updates

#### Logrus Import Path
- **Changed**: All imports from `github.com/Sirupsen/logrus` to `github.com/sirupsen/logrus`
- **Reason**: The canonical import path changed; the old path redirects but should be updated
- **Files affected**: All non-vendor `.go` files containing logrus imports

#### Go Modules
- **Added**: `go.mod` file for modern dependency management
- **Go version**: Set to 1.21
- **Dependencies**: Includes all necessary dependencies with updated versions

## Testing the Changes

### Using Vagrant

1. Ensure you have VirtualBox and Vagrant installed
2. Run from the project directory:
   ```bash
   vagrant up
   ```

3. This will:
   - Create an Ubuntu 24.04 VM
   - Install Docker and Docker Compose
   - Install Go 1.21.5
   - Set up the development environment
   - Build malice

### Using Docker

Build the Docker image:
```bash
cd .docker
docker build --build-arg VERSION=v0.3.28 -t malice/engine:latest .
```

## Additional Notes

### Elasticsearch Memory Requirements
The `vm.max_map_count=262144` setting is still required for Elasticsearch to run properly. This is now applied both persistently (via `/etc/sysctl.conf`) and immediately (via `sysctl -w`).

### Docker Compose Version
Both the plugin (`docker-compose-plugin`) and standalone binary are installed for maximum compatibility. Use either:
- `docker compose` (plugin)
- `docker-compose` (standalone)

### Go Module Migration
The project now uses Go modules instead of `dep`. To update dependencies:
```bash
go mod tidy
go mod download
```

## Compatibility Matrix

| Component | Old Version | New Version |
|-----------|-------------|-------------|
| Ubuntu | 16.04 (Xenial) | 24.04 (Noble) |
| Alpine Linux | 3.8 | 3.19 |
| Go | 1.11.2 | 1.21.5 |
| Docker Compose | 1.8.0 | Latest |
| Dependency Manager | dep | Go modules |
| logrus import | Sirupsen | sirupsen |

## Known Issues

### Vendor Directory
The `vendor/` directory still contains old imports. If rebuilding from scratch, run:
```bash
go mod vendor
```
This will regenerate the vendor directory with correct imports.

## Future Improvements

1. Consider updating to Go 1.22 or later
2. Update Alpine to 3.20 (latest stable)
3. Migrate away from deprecated Docker API calls
4. Update all plugin dependencies to latest versions
5. Consider replacing deprecated packages in dependencies

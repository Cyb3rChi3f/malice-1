#!/bin/bash
# Deep Docker Connection Debugging Script
# This will help identify exactly why malice can't connect to Docker

echo "=================================================="
echo "Deep Docker Connection Debugging"
echo "=================================================="
echo ""

echo "=== System Information ==="
echo "User: $(whoami)"
echo "Groups: $(groups)"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo ""

echo "=== Docker Status ==="
echo "Docker daemon status:"
systemctl is-active docker && echo "✅ Running" || echo "❌ Not running"
echo ""

echo "Docker version:"
docker version 2>&1 | head -20
echo ""

echo "=== Docker Socket ==="
echo "Socket location:"
ls -lZ /var/run/docker.sock 2>&1
echo ""

echo "Socket ownership:"
stat -c '%U:%G %a' /var/run/docker.sock 2>&1
echo ""

echo "=== Environment Variables ==="
echo "DOCKER_HOST: ${DOCKER_HOST:-<not set>}"
echo "DOCKER_TLS_VERIFY: ${DOCKER_TLS_VERIFY:-<not set>}"
echo "DOCKER_CERT_PATH: ${DOCKER_CERT_PATH:-<not set>}"
echo ""

echo "=== Testing Docker CLI ==="
echo "Running: docker ps"
docker ps 2>&1
echo ""

echo "=== Testing with explicit socket ==="
echo "Running: docker -H unix:///var/run/docker.sock ps"
docker -H unix:///var/run/docker.sock ps 2>&1
echo ""

echo "=== Testing Docker API directly ==="
echo "Running: curl --unix-socket /var/run/docker.sock http://localhost/version"
curl --unix-socket /var/run/docker.sock http://localhost/version 2>&1
echo ""
echo ""

echo "=== Checking for alternative socket locations ==="
for socket in /var/run/docker.sock /run/docker.sock ~/.docker/docker.sock; do
    if [ -S "$socket" ]; then
        echo "✅ Found socket: $socket"
        ls -l "$socket"
    else
        echo "❌ Not found: $socket"
    fi
done
echo ""

echo "=== Malice Binary Information ==="
if command -v malice &> /dev/null; then
    echo "Malice location: $(which malice)"
    echo "Malice permissions:"
    ls -l $(which malice)
    echo ""
    echo "Testing malice version:"
    malice --version 2>&1
    echo ""
    echo "Running malice with Docker debug:"
    DOCKER_API_VERSION= malice elk 2>&1 | head -20
else
    echo "❌ malice not found in PATH"
    echo "Current PATH: $PATH"
fi
echo ""

echo "=== SELinux Context Check ==="
if command -v getenforce &> /dev/null; then
    echo "SELinux mode: $(getenforce)"
    echo "Docker socket context:"
    ls -Z /var/run/docker.sock 2>&1
    echo ""
    echo "Recent SELinux denials related to docker:"
    sudo ausearch -m avc -ts recent 2>/dev/null | grep docker | tail -5
else
    echo "SELinux not available"
fi
echo ""

echo "=== Testing a simple Docker API call ==="
cat > /tmp/test-docker.go << 'EOF'
package main

import (
    "context"
    "fmt"
    "github.com/docker/docker/client"
)

func main() {
    cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
    if err != nil {
        fmt.Printf("❌ Error creating client: %v\n", err)
        return
    }
    defer cli.Close()

    info, err := cli.Info(context.Background())
    if err != nil {
        fmt.Printf("❌ Error getting info: %v\n", err)
        return
    }

    fmt.Printf("✅ Docker connection successful!\n")
    fmt.Printf("Docker version: %s\n", info.ServerVersion)
    fmt.Printf("OS: %s\n", info.OperatingSystem)
    fmt.Printf("Architecture: %s\n", info.Architecture)
}
EOF

echo "Compiling test program..."
cd /tmp
if go mod init test-docker 2>/dev/null; then
    go get github.com/docker/docker/client 2>&1 | tail -5
fi
if go build -o test-docker test-docker.go 2>&1; then
    echo "Running test program:"
    ./test-docker 2>&1
    rm -f test-docker test-docker.go
else
    echo "❌ Failed to compile test program"
fi
echo ""

echo "=================================================="
echo "Debugging Complete"
echo "=================================================="
echo ""
echo "If docker CLI works but malice doesn't, the issue is in malice."
echo "Please share the output above for further diagnosis."
echo ""

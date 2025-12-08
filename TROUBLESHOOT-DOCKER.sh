#!/bin/bash
# Docker Connection Troubleshooting Script for Rocky Linux
# Run this to diagnose Docker connectivity issues

echo "=================================================="
echo "Docker Connection Troubleshooting"
echo "=================================================="
echo ""

echo "1. Checking if Docker daemon is running..."
if systemctl is-active --quiet docker; then
    echo "   ✅ Docker daemon is running"
else
    echo "   ❌ Docker daemon is NOT running"
    echo "   Fix: sudo systemctl start docker"
    echo ""
    read -p "   Start Docker now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "   ✅ Docker started and enabled"
    fi
fi

echo ""
echo "2. Checking Docker socket..."
if [ -S /var/run/docker.sock ]; then
    echo "   ✅ Docker socket exists: /var/run/docker.sock"
    ls -l /var/run/docker.sock
else
    echo "   ❌ Docker socket NOT found at /var/run/docker.sock"
fi

echo ""
echo "3. Checking user groups..."
CURRENT_USER=$(whoami)
if groups $CURRENT_USER | grep -q docker; then
    echo "   ✅ User '$CURRENT_USER' is in docker group"
else
    echo "   ❌ User '$CURRENT_USER' is NOT in docker group"
    echo "   Fix: sudo usermod -aG docker $CURRENT_USER"
    echo "   Note: You'll need to log out and back in for this to take effect"
    echo ""
    read -p "   Add user to docker group now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo usermod -aG docker $CURRENT_USER
        echo "   ✅ User added to docker group"
        echo "   ⚠️  You must log out and log back in for this to take effect!"
        echo "   Or run: newgrp docker"
    fi
fi

echo ""
echo "4. Testing Docker connection..."
if docker ps &>/dev/null; then
    echo "   ✅ Docker connection successful!"
    docker ps
else
    echo "   ❌ Cannot connect to Docker"
    echo ""
    echo "   Checking for SELinux issues..."

    # Check SELinux status
    if command -v getenforce &> /dev/null; then
        SELINUX_STATUS=$(getenforce)
        echo "   SELinux status: $SELINUX_STATUS"

        if [ "$SELINUX_STATUS" = "Enforcing" ]; then
            echo ""
            echo "   SELinux is in enforcing mode. Checking context..."
            ls -Z /var/run/docker.sock 2>/dev/null || echo "   Could not check SELinux context"
            echo ""
            echo "   To fix SELinux issues, run:"
            echo "   sudo setsebool -P container_manage_cgroup on"
            echo "   sudo chcon -t container_file_t /var/run/docker.sock"
            echo ""
            read -p "   Apply SELinux fixes now? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                sudo setsebool -P container_manage_cgroup on
                sudo chcon -t container_file_t /var/run/docker.sock
                echo "   ✅ SELinux fixes applied"
            fi
        fi
    fi
fi

echo ""
echo "5. Checking DOCKER_HOST environment variable..."
if [ -z "$DOCKER_HOST" ]; then
    echo "   ✅ DOCKER_HOST is not set (using default socket)"
else
    echo "   ⚠️  DOCKER_HOST is set to: $DOCKER_HOST"
    echo "   This might override the default socket location"
fi

echo ""
echo "6. Testing Docker with sudo..."
if sudo docker ps &>/dev/null; then
    echo "   ✅ Docker works with sudo"
    echo "   This confirms Docker is running but you have a permissions issue"
else
    echo "   ❌ Docker doesn't work even with sudo"
    echo "   Docker daemon may not be running or is misconfigured"
fi

echo ""
echo "=================================================="
echo "Diagnosis Complete"
echo "=================================================="
echo ""
echo "Quick fixes to try:"
echo ""
echo "1. If Docker not running:"
echo "   sudo systemctl start docker"
echo "   sudo systemctl enable docker"
echo ""
echo "2. If permission denied:"
echo "   sudo usermod -aG docker $USER"
echo "   newgrp docker  # or log out and back in"
echo ""
echo "3. If SELinux blocking (Rocky Linux specific):"
echo "   sudo setsebool -P container_manage_cgroup on"
echo "   sudo chcon -t container_file_t /var/run/docker.sock"
echo ""
echo "4. Restart Docker after changes:"
echo "   sudo systemctl restart docker"
echo ""
echo "5. Test connection:"
echo "   docker ps"
echo ""

#!/bin/bash
# Fix Go version dependency conflict
# This script constrains dependencies to versions compatible with Go 1.21

set -e

echo "=================================================="
echo "Fixing Go Version Dependency Conflict"
echo "=================================================="
echo ""

cd /root/go/src/github.com/maliceio/malice

echo "Current Go version:"
go version
echo ""

echo "Step 1: Cleaning module cache..."
go clean -modcache

echo "Step 2: Updating go.mod with version constraints..."
# The go.mod file should already have the constraints from the update

echo "Step 3: Downloading dependencies with constraints..."
go mod download

echo "Step 4: Running go mod tidy..."
go mod tidy

echo "Step 5: Verifying dependencies..."
go mod verify

echo "Step 6: Building malice..."
go build -mod=mod -o malice

echo ""
echo "=================================================="
echo "Fix Complete!"
echo "=================================================="
echo ""
echo "Malice has been built successfully."
echo "To install it system-wide, run:"
echo "  sudo cp malice /usr/local/bin/malice"
echo ""

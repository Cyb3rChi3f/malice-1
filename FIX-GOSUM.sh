#!/bin/bash
# Script to fix missing go.sum entries
# Run this from your malice project root directory

set -e

echo "=================================================="
echo "Fixing Missing go.sum Entries"
echo "=================================================="
echo ""

# Check if we're in the right directory
if [ ! -f "go.mod" ]; then
    echo "❌ Error: go.mod not found. Please run this script from the malice project root."
    exit 1
fi

echo "Step 1: Running go mod tidy..."
echo "This will add missing dependencies and update go.sum"
go mod tidy -v

echo ""
echo "Step 2: Downloading all dependencies..."
go mod download

echo ""
echo "Step 3: Verifying dependencies..."
go mod verify

echo ""
echo "=================================================="
echo "Fix Complete!"
echo "=================================================="
echo ""
echo "You can now build the project:"
echo "  go build -mod=mod -o malice"
echo ""

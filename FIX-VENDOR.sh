#!/bin/bash
# Script to fix vendor directory inconsistency issue
# Run this from your malice project root directory

set -e

echo "=================================================="
echo "Fixing Vendor Directory Inconsistency"
echo "=================================================="
echo ""

# Check if we're in the right directory
if [ ! -f "go.mod" ]; then
    echo "❌ Error: go.mod not found. Please run this script from the malice project root."
    exit 1
fi

echo "Step 1: Backing up vendor directory (if it exists)..."
if [ -d "vendor" ]; then
    mv vendor vendor.backup.$(date +%Y%m%d_%H%M%S)
    echo "✅ Vendor directory backed up"
else
    echo "ℹ️  No vendor directory found (already clean)"
fi

echo ""
echo "Step 2: Downloading dependencies..."
go mod download
echo "✅ Dependencies downloaded"

echo ""
echo "Step 3: Testing build without vendor..."
go build -mod=mod -o /tmp/malice-test ./
if [ $? -eq 0 ]; then
    echo "✅ Build successful without vendoring"
    rm -f /tmp/malice-test
else
    echo "⚠️  Build had some warnings but may still work"
fi

echo ""
echo "=================================================="
echo "Fix Complete!"
echo "=================================================="
echo ""
echo "You can now use go commands normally:"
echo "  go build -mod=mod"
echo "  go run -mod=mod main.go"
echo "  go test -mod=mod ./..."
echo ""
echo "If you need vendoring, regenerate it with:"
echo "  go mod vendor"
echo ""

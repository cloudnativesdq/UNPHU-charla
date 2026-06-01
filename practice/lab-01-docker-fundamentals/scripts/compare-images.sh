#!/bin/bash
set -e

echo "🔍 Comparing Docker Images Sizes..."
echo ""

# Function to get image size in MB
get_size_mb() {
    docker images --format "{{.Size}}" "$1" | sed 's/GB/*1024/;s/MB//;s/KB/\/1024/' | bc 2>/dev/null || echo "0"
}

# Check if images exist
if ! docker images | grep -q "link-backend:basic"; then
    echo "❌ link-backend:basic not found. Build it first."
    exit 1
fi

if ! docker images | grep -q "link-backend:optimized"; then
    echo "❌ link-backend:optimized not found. Build it first."
    exit 1
fi

# Display comparison
echo "Backend Images:"
docker images | grep "link-backend" | awk '{printf "%-30s %-15s %-15s\n", $1":"$2, $7, $4" "$5}'

echo ""
echo "Frontend Images:"
docker images | grep "link-frontend" | awk '{printf "%-30s %-15s %-15s\n", $1":"$2, $7, $4" "$5}'

echo ""
echo "✅ Comparison complete!"

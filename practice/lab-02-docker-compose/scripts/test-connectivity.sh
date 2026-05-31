#!/bin/bash
set -e

echo "🧪 Testing connectivity between services..."

# Test Redis
echo "1. Testing Redis..."
docker-compose exec redis redis-cli ping || { echo "❌ Redis failed"; exit 1; }
echo "✅ Redis OK"

# Test Backend
echo "2. Testing Backend..."
curl -f http://localhost:5000/health || { echo "❌ Backend failed"; exit 1; }
echo "✅ Backend OK"

# Test Frontend
echo "3. Testing Frontend..."
curl -f http://localhost:5173/health || { echo "❌ Frontend failed"; exit 1; }
echo "✅ Frontend OK"

# Test Backend -> Redis connection
echo "4. Testing Backend -> Redis connection..."
RESPONSE=$(curl -s http://localhost:5000/health)
if echo "$RESPONSE" | grep -q "redis.*connected"; then
    echo "✅ Backend connected to Redis"
else
    echo "❌ Backend cannot reach Redis"
    exit 1
fi

echo ""
echo "🎉 All connectivity tests passed!"

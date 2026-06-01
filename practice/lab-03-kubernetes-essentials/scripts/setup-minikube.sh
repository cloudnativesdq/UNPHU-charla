#!/bin/bash
set -e

echo "🚀 Setting up Minikube for Link Shortener..."

# Check if minikube is installed
if ! command -v minikube &> /dev/null; then
    echo "❌ Minikube not found. Install it first:"
    echo "https://minikube.sigs.k8s.io/docs/start/"
    exit 1
fi

# Stop existing cluster if running
if minikube status &> /dev/null; then
    echo "⚠️  Stopping existing Minikube cluster..."
    minikube stop
fi

# Start with optimized settings for 8GB RAM laptops
echo "🔧 Starting Minikube (cpus=2, memory=4096MB)..."
minikube start --cpus=2 --memory=4096 --driver=docker

# Enable addons
echo "📦 Enabling addons..."
minikube addons enable metrics-server
minikube addons enable ingress

# Configure Docker environment
echo "🐳 Configuring Docker to use Minikube..."
eval $(minikube docker-env)

echo ""
echo "✅ Minikube setup complete!"
echo ""
echo "Run these commands to build images inside Minikube:"
echo "  eval \$(minikube docker-env)"
echo "  docker build -t link-backend:v1 ../../apps/backend"
echo "  docker build -t link-frontend:v1 ../../apps/frontend"

#!/bin/bash
set -e

NAMESPACE="linkshortener"
OUTPUT_DIR="./logs-$(date +%Y%m%d-%H%M%S)"

echo "📋 Collecting logs from namespace: $NAMESPACE"
mkdir -p "$OUTPUT_DIR"

# Collect pod logs
echo "1. Collecting pod logs..."
for pod in $(kubectl get pods -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}'); do
    echo "  - $pod"
    kubectl logs -n $NAMESPACE $pod > "$OUTPUT_DIR/${pod}.log" 2>&1 || true
done

# Collect events
echo "2. Collecting events..."
kubectl get events -n $NAMESPACE --sort-by='.lastTimestamp' > "$OUTPUT_DIR/events.txt"

# Collect resource status
echo "3. Collecting resource status..."
kubectl get all -n $NAMESPACE -o wide > "$OUTPUT_DIR/resources.txt"

# Collect descriptions
echo "4. Collecting pod descriptions..."
kubectl describe pods -n $NAMESPACE > "$OUTPUT_DIR/pod-descriptions.txt"

echo ""
echo "✅ Logs collected in: $OUTPUT_DIR"

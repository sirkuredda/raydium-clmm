#!/bin/bash

IMAGE_NAME="my-solana-app"
FILE_NAME="id.json"

# --- 1. Check for the required file ---
if [ ! -f "$FILE_NAME" ]; then
  echo "🛑 ERROR: '$FILE_NAME' is missing in the current directory."
  echo "Please place the file with your current solana id here before running the build."
  exit 1
fi

echo "✅ '$FILE_NAME' found. Starting Docker build..."
echo "------------------------------------------------"

# --- 2. Build the Docker Image ---
# The -t flag tags the image with a human-readable name
# The . at the end specifies the build context (current directory)
if docker build -t "$IMAGE_NAME" . ; then
    echo "------------------------------------------------"
    echo "✅ Image '$IMAGE_NAME' built successfully."

    # --- 3. Clean up intermediate build space ---
    echo "🧹 Cleaning up intermediate build cache and unused layers..."
    docker rmi $IMAGE_NAME

    echo "✅ Cleanup complete."
else
    echo "------------------------------------------------"
    echo "❌ Docker build FAILED. Check the errors above."
    exit 1
fi
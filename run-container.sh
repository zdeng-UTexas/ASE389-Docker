#!/bin/bash

# Get your local IP address
LOCAL_IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

# Allow X11 forwarding from the container
xhost + $LOCAL_IP

# Get the absolute path of the current directory's workspace folder
WORKSPACE_PATH=$(pwd)/workspace
echo "=== DEBUG INFO ==="
echo "Current directory: $(pwd)"
echo "Workspace path: $WORKSPACE_PATH"
echo "Local workspace contents:"
ls -la "$WORKSPACE_PATH"
echo "=================="

# Start a container with X11 forwarding from an image
docker run -it \
    --platform linux/amd64 \
    -e DISPLAY=$LOCAL_IP:0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v "$WORKSPACE_PATH":/root/workspace \
    -p 7001:7000 \
    --name ubuntu18-container \
    ubuntu18-conda-x11

# Clean up X11 permissions after container stops
xhost - $LOCAL_IP

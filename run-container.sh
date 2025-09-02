#!/bin/bash

# Get your local IP address
LOCAL_IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

# Allow X11 forwarding from the container
xhost + $LOCAL_IP

# Run the container with X11 forwarding
docker run -it --rm \
    --platform linux/amd64 \
    -e DISPLAY=$LOCAL_IP:0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --name ubuntu18-conda \
    ubuntu18-conda-x11

# Clean up X11 permissions after container stops
xhost - $LOCAL_IP

# Use Ubuntu 18.04 base image for x86_64 architecture
FROM --platform=linux/amd64 ubuntu:18.04
# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies for X11 forwarding and GUI applications
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    bzip2 \
    ca-certificates \
    git \
    vim \
    x11-apps \
    xauth \
    xvfb \
    libxrender1 \
    libxtst6 \
    libxrandr2 \
    libasound2-dev \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libxss1 \
    libgconf-2-4 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxfixes3 \
    libnss3 \
    libcups2 \
    libdrm2 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Miniconda as root
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /root/miniconda3 && \
    rm miniconda.sh

# Add conda to PATH
ENV PATH="/root/miniconda3/bin:${PATH}"

# Initialize conda for bash
RUN conda init bash

# Copy environment file to root directory
COPY environment.yml /root/environment.yml

# Create the conda environment
RUN conda env create -f /root/environment.yml

# Set up X11 forwarding
ENV DISPLAY=:0

# Activate the environment by default
RUN echo "conda activate hw1" >> /root/.bashrc

# Set the working directory
WORKDIR /root/workspace

# Default command
CMD ["/bin/bash"]
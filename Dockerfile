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
    libxrandr2 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libdrm2 \
    libxss1 \
    libgconf-2-4 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to user
USER user
WORKDIR /home/user

# Download and install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /home/user/miniconda3 && \
    rm miniconda.sh

# Add conda to PATH
ENV PATH="/home/user/miniconda3/bin:${PATH}"

# Initialize conda
RUN conda init bash

# Create the conda environment file
COPY --chown=user:user environment.yml /home/user/environment.yml

# Create the conda environment
RUN conda env create -f environment.yml

# Set up X11 forwarding
ENV DISPLAY=:0

# Activate the environment by default
RUN echo "conda activate hw1" >> /home/user/.bashrc

# Set the working directory
WORKDIR /home/user/workspace

# Default command
CMD ["/bin/bash"]
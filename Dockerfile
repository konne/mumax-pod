FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# Reduce the number of additional layers and packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    fuse3 \
    gnuplot \
    ffmpeg \
    python3 \
    python3-pip \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and unpack Mumax3
RUN curl -L https://mumax.ugent.be/mumax3-binaries/mumax3.10_linux_cuda11.0.tar.gz | tar xz -C /usr/local/bin --strip-components 1

# Install rclone
RUN curl https://rclone.org/install.sh |  bash

# install python stuff
RUN pip install notebook && \
    pip install papermill && \
    pip install numpy && \
    pip install discretisedfield

# # Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Copy the start script into the image
COPY start.sh /start.sh
RUN chmod +x /start.sh

# # Command to run the start script
CMD ["/start.sh"]

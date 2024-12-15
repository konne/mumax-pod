FROM ubuntu:22.04
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
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Add the NVIDIA driver PPA and install the driver
RUN add-apt-repository ppa:graphics-drivers/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends nvidia-driver-470 \
    && rm -rf /var/lib/apt/lists/*

# Install rclone
RUN https://rclone.org/install.sh | sh

# Download and unpack Mumax3
RUN curl -L https://mumax.ugent.be/mumax3-binaries/mumax3.10_linux_cuda11.0.tar.gz | tar xz -C /usr/local/bin

# Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Copy the start script into the image
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Command to run the start script
CMD ["/start.sh"]

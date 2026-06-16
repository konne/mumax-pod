FROM nvidia/cuda:12.6.3-devel-ubuntu24.04

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# Reduce the number of additional layers and packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    fuse3 \
    gnuplot \
    ffmpeg \
    python3 \
    python3-venv \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
RUN python3 -m venv "${VIRTUAL_ENV}"

# Download and unpack Mumax3
RUN curl -L https://mumax.ugent.be/mumax3-binaries/mumax3.12_linux_cuda12.6.tar.gz | tar xz -C /usr/local/bin --strip-components 1

# Install rclone
RUN curl https://rclone.org/install.sh |  bash

# Install Python tools into the virtual environment.
RUN python -m pip install --no-cache-dir --upgrade pip && \
    python -m pip install --no-cache-dir notebook papermill numpy discretisedfield

# # Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Copy the start script into the image
COPY start.sh /start.sh
RUN chmod +x /start.sh

# # Command to run the start script
CMD ["/start.sh"]

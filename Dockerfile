FROM debian:bookworm-slim

# Install owserver (1-Wire) and knxd (KNX/EIB)
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    owserver \
    knxd \
    knxd-tools \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /sbin/nologin owfs-knxd

# Create config directories
RUN mkdir -p /etc/owfs && chown owfs-knxd:owfs-knxd /etc/owfs

# Expose owserver port and KNX port
EXPOSE 4304 3671

# Copy entrypoint and liveness probe scripts
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY liveness-probe.sh /usr/local/bin/liveness-probe.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/liveness-probe.sh

# Set environment variables with defaults
ENV KNXD_ARGS=""

# Entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

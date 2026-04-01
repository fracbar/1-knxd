# 1-knxd
A Gateway Container with 1-Wire (owfs server and tools) and KNX (knxd)

## Image Description

The Docker image is based on **Debian 12 (Bookworm) Slim** and includes the following packages:

- **owserver** - 1-Wire file system server
- **owfs-clients** - 1-Wire file system client tools
- **knxd** - KNX/EIB daemon for home automation
- **knxd-tools** - KNX/EIB utilities
- **ca-certificates** - For SSL/TLS support

The image also includes a non-root user (`owfs-knxd`) for improved security and a liveness probe script to monitor service health.

## Configuration

Both services are optional and must be explicitly configured:

### owserver (1-Wire)

Pass the owserver configuration file as a volume mount:

```bash
docker run -d \
  -v /path/to/owserver.conf:/etc/owfs/owserver.conf \
  owfs-knxd
```

- **Config path in container:** `/etc/owfs/owserver.conf`
- **Port:** 4304 (exposed)
- If the config file is not provided, owserver will not start

### knxd (KNX/EIB)

Pass KNX parameters via the `KNXD_ARGS` environment variable:

```bash
docker run -d \
  -e KNXD_ARGS="-e 1.1.250 -E 1.1.251:8 ipt:localhost" \
  owfs-knxd
```

- **Environment variable:** `KNXD_ARGS`
- **Port:** 3671 (exposed)
- If `KNXD_ARGS` is not set, knxd will not start

### Running Both Services

```bash
docker run -d \
  -v /path/to/owserver.conf:/etc/owfs/owserver.conf \
  -e KNXD_ARGS="-e 1.1.250 -E 1.1.251:8 ipt:localhost" \
  owfs-knxd
```

### Health Check

A liveness probe is available at `/usr/local/bin/liveness-probe.sh` to verify that all configured services are running. This can be used in Kubernetes or Docker health checks.


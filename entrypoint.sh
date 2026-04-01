#!/bin/sh
set -e

OWSERVER_CONFIG="${OWSERVER_CONFIG:-/etc/owfs/owserver.conf}"
KNXD_ARGS="${KNXD_ARGS:-}"

# Flag to track if any service started
SERVICES_STARTED=0

# Start owserver if config file exists
if [ -f "$OWSERVER_CONFIG" ]; then
    echo "Starting owserver with config: $OWSERVER_CONFIG"
    owserver -c "$OWSERVER_CONFIG" &
    SERVICES_STARTED=$((SERVICES_STARTED + 1))
else
    echo "Warning: owserver config not found at $OWSERVER_CONFIG"
    echo "To enable owserver, mount a config file to: $OWSERVER_CONFIG"
fi

# Start knxd if KNXD_ARGS is provided
if [ -n "$KNXD_ARGS" ]; then
    echo "Starting knxd with args: $KNXD_ARGS"
    eval "knxd $KNXD_ARGS" &
    SERVICES_STARTED=$((SERVICES_STARTED + 1))
else
    echo "Warning: KNXD_ARGS not set"
    echo "To enable knxd, set KNXD_ARGS environment variable"
fi

# Exit if no services were started
if [ $SERVICES_STARTED -eq 0 ]; then
    echo "Error: No services configured. Please provide:"
    echo "  - owserver config file at: $OWSERVER_CONFIG"
    echo "  - KNXD_ARGS environment variable"
    exit 1
fi

# Wait for all background processes
wait
